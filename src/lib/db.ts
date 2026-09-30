import { DatabaseSync } from "node:sqlite";
import { mkdirSync } from "node:fs";
import { dirname } from "node:path";
import { config, AppError } from "./config";
import { stitch, matchExpectations } from "./activity";
import type { Activity, Expectation, ExpectationMatch, RingDevice, RingEvent, Snapshot } from "./types";

export class Store {
  readonly db: DatabaseSync;
  constructor(path: string, readonly mode: "fixture" | "ring", readonly zone: string, readonly ringDeviceMode: "configured" | "playground" = "configured") {
    if (path !== ":memory:") mkdirSync(dirname(path), { recursive: true });
    this.db = new DatabaseSync(path);
    this.db.exec(`PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL; PRAGMA busy_timeout=5000;
      CREATE TABLE IF NOT EXISTS metadata(key TEXT PRIMARY KEY, value TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS RingDevice(id TEXT PRIMARY KEY, externalDeviceId TEXT UNIQUE NOT NULL, name TEXT NOT NULL, locationName TEXT NOT NULL, deviceType TEXT NOT NULL, zone TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS RingEvent(id TEXT PRIMARY KEY, externalEventId TEXT NOT NULL, deviceId TEXT NOT NULL REFERENCES RingDevice(id), eventType TEXT NOT NULL, occurredAt TEXT NOT NULL, rawPayload TEXT NOT NULL, source TEXT NOT NULL, UNIQUE(deviceId,externalEventId));
      CREATE TABLE IF NOT EXISTS Activity(id TEXT PRIMARY KEY, type TEXT NOT NULL, startedAt TEXT NOT NULL, endedAt TEXT, label TEXT NOT NULL, confidence REAL NOT NULL, summary TEXT NOT NULL, locationName TEXT NOT NULL, source TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS ActivityEvent(activityId TEXT REFERENCES Activity(id) ON DELETE CASCADE, ringEventId TEXT REFERENCES RingEvent(id), PRIMARY KEY(activityId,ringEventId));
      CREATE TABLE IF NOT EXISTS Expectation(id TEXT PRIMARY KEY, originalText TEXT NOT NULL, category TEXT NOT NULL, personOrService TEXT NOT NULL, expectedDate TEXT NOT NULL, startWindow TEXT NOT NULL, endWindow TEXT NOT NULL, location TEXT NOT NULL, status TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS ExpectationMatch(expectationId TEXT REFERENCES Expectation(id), activityId TEXT REFERENCES Activity(id) ON DELETE CASCADE, confidence REAL NOT NULL, explanation TEXT NOT NULL, PRIMARY KEY(expectationId,activityId));
      CREATE TABLE IF NOT EXISTS WebhookReceipt(requestId TEXT PRIMARY KEY);
      CREATE INDEX IF NOT EXISTS event_time ON RingEvent(occurredAt);`);
    // Older Ring databases predate Playground support and contain configured devices.
    if (mode === "ring" && ringDeviceMode === "playground" && !this.db.prepare("SELECT 1 FROM metadata WHERE key='ringDeviceMode'").get() && this.db.prepare("SELECT 1 FROM RingDevice LIMIT 1").get()) {
      this.db.close(); throw new AppError("Use a new Playground database to keep it separate from existing Ring records.", 503);
    }
    for (const [key, value] of [["ringMode", mode], ["timeZone", zone], ...(mode === "ring" ? [["ringDeviceMode", ringDeviceMode]] : [])]) {
      this.db.prepare("INSERT OR IGNORE INTO metadata VALUES (?,?)").run(key, value);
      const saved = this.db.prepare("SELECT value FROM metadata WHERE key=?").get(key);
      if (saved?.value !== value) { this.db.close(); throw new AppError("Database source setup or timezone differs. Use a separate AROUND_DB_PATH to keep evidence consistent.", 503); }
    }
  }
  close() { this.db.close(); }
  snapshot(): Snapshot {
    const activities = this.db.prepare("SELECT * FROM Activity ORDER BY startedAt DESC").all() as unknown as Activity[];
    for (const a of activities) a.eventIds = this.db.prepare("SELECT ringEventId FROM ActivityEvent WHERE activityId=? ORDER BY ringEventId").all(a.id).map(e => String(e.ringEventId));
    return { devices: this.db.prepare("SELECT * FROM RingDevice").all() as unknown as RingDevice[], events: this.db.prepare("SELECT * FROM RingEvent ORDER BY occurredAt").all() as unknown as RingEvent[], activities,
      expectations: this.db.prepare("SELECT * FROM Expectation ORDER BY expectedDate DESC, startWindow").all() as unknown as Expectation[], matches: this.db.prepare("SELECT * FROM ExpectationMatch").all() as unknown as ExpectationMatch[] };
  }
  transaction(work: () => void) {
    this.db.exec("BEGIN IMMEDIATE");
    try { work(); this.db.exec("COMMIT"); } catch (error) { this.db.exec("ROLLBACK"); throw error; }
  }
  saveExpectation(e: Expectation) {
    this.transaction(() => {
      this.db.prepare("INSERT INTO Expectation (id,originalText,category,personOrService,expectedDate,startWindow,endWindow,location,status) VALUES (?,?,?,?,?,?,?,?,?)").run(e.id, e.originalText, e.category, e.personOrService, e.expectedDate, e.startWindow, e.endWindow, e.location, e.status);
      this.rebuild();
    });
  }
  ingest(devices: RingDevice[], events: RingEvent[], requestId?: string) {
    let inserted = 0;
    this.transaction(() => {
      if (requestId && this.db.prepare("SELECT 1 FROM WebhookReceipt WHERE requestId=?").get(requestId)) return;
      for (const d of devices) this.db.prepare("INSERT INTO RingDevice VALUES (?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET name=excluded.name, locationName=excluded.locationName, deviceType=excluded.deviceType, zone=excluded.zone").run(d.id, d.externalDeviceId, d.name, d.locationName, d.deviceType, d.zone);
      for (const e of events) {
        if (e.source !== this.mode) throw new AppError("Cannot mix fixture and Ring evidence.");
        // A webhook can enrich generic history motion for the same event ID.
        const result = this.db.prepare(`INSERT INTO RingEvent (id,externalEventId,deviceId,eventType,occurredAt,rawPayload,source) VALUES (?,?,?,?,?,?,?) ON CONFLICT(deviceId,externalEventId) DO UPDATE SET eventType=excluded.eventType, rawPayload=excluded.rawPayload WHERE RingEvent.eventType='motion' AND excluded.eventType IN ('person','vehicle')`).run(e.id, e.externalEventId, e.deviceId, e.eventType, e.occurredAt, e.rawPayload, e.source);
        inserted += Number(result.changes);
      }
      if (requestId) this.db.prepare("INSERT INTO WebhookReceipt VALUES (?)").run(requestId);
      this.rebuild();
    });
    return inserted;
  }
  private rebuild() {
    const s = this.snapshot(), activities = stitch(s.events, s.devices, this.zone), matches = matchExpectations(s.expectations, activities, this.zone);
    this.db.exec("DELETE FROM ExpectationMatch; DELETE FROM ActivityEvent; DELETE FROM Activity;");
    for (const a of activities) {
      this.db.prepare("INSERT INTO Activity VALUES (?,?,?,?,?,?,?,?,?)").run(a.id, a.type, a.startedAt, a.endedAt, a.label, a.confidence, a.summary, a.locationName, a.source);
      for (const id of a.eventIds) this.db.prepare("INSERT INTO ActivityEvent VALUES (?,?)").run(a.id, id);
    }
    for (const m of matches) this.db.prepare("INSERT INTO ExpectationMatch VALUES (?,?,?,?)").run(m.expectationId, m.activityId, m.confidence, m.explanation);
    for (const e of s.expectations) {
      const found = matches.filter(m => m.expectationId === e.id);
      const status = !found.length ? "expected" : found.some(m => m.confidence < 0.6) ? "ambiguous" : "likely_match";
      this.db.prepare("UPDATE Expectation SET status=? WHERE id=?").run(status, e.id);
    }
  }
}
let singleton: Store | undefined;
export function store() { const c = config(); return singleton ??= new Store(c.dbPath, c.ringMode, c.timeZone, c.ringDeviceMode); }
