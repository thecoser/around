import { test } from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { syncRing, normalizeHistory } from "../src/lib/ring/api";
import { Store } from "../src/lib/db";
import { ask, briefingFacts, validateExpectation, visitFact } from "../src/lib/ai";
import { stitch } from "../src/lib/activity";
import { fixtureDevices, fixtureEvents } from "../src/lib/ring/fixture";

const zone = "America/New_York", day = "2026-09-28";
const now = new Date(`${day}T18:00:00Z`);
const row = { type: "history-events", id: "view-1", attributes: { event_type: "on_demand", start: Date.parse(`${day}T14:41:00Z`), end: Date.parse(`${day}T14:42:00Z`) }, relationships: { source: { data: { type: "devices", id: "sandbox-camera" } } } };

test("Playground discovery to storage to answer uses one device, never a visit or saved token", async () => {
  const values = { RING_MODE: "ring", RING_DEVICE_MODE: "playground", AI_MODE: "fixture", AROUND_TIME_ZONE: zone };
  const previous = Object.fromEntries(Object.keys(values).map(k => [k, process.env[k]]));
  Object.assign(process.env, values);
  const db = new Store(":memory:", "ring", zone, "playground");
  let calls = 0;
  const fetcher = (async (input: URL | RequestInfo, init?: RequestInit) => {
    calls++;
    assert.equal((init?.headers as Record<string, string>).Authorization, "Bearer request-only-test-token");
    const url = new URL(String(input));
    assert.equal(url.origin, "https://api.amazonvision.com");
    if (url.pathname === "/v1/devices") return Response.json({ data: [{ type: "devices", id: "sandbox-camera", attributes: { name: "DoorbellPro" } }] });
    assert.equal(url.pathname, "/v1/history/devices/sandbox-camera/events");
    assert.equal(url.search, "");
    return Response.json({ data: [row] });
  }) as typeof fetch;
  try {
    const e = validateExpectation({ personOrService: "plumber", expectedDate: day, startWindow: "10:00", endWindow: "13:00", location: "Home" }, "The plumber is coming today between 10 and 1.", zone);
    db.saveExpectation(e);
    const data = await syncRing(fetcher, "request-only-test-token");
    assert.equal(calls, 2);
    assert.equal(data.devices.length, 1);
    assert.equal(data.devices[0].zone, "other");
    assert.equal(data.devices[0].locationName, "Ring Playground");
    assert.equal(db.ingest(data.devices, data.events), 1);
    assert.equal(db.ingest(data.devices, data.events), 0);
    const s = db.snapshot();
    assert.equal(s.activities[0].type, "live_view");
    assert.equal(s.activities[0].label, "Live view requested");
    assert.equal(s.activities[0].endedAt, null);
    assert.equal(s.matches.length, 0);
    assert.equal(s.expectations[0].status, "expected");
    assert.equal(JSON.stringify(s).includes("request-only-test-token"), false);
    const answer = await ask("Did the plumber come?", s, now);
    assert.match(answer.text, /don't have enough recorded activity/);
    assert.match(answer.text, /live-view request around 10:41 AM/);
    assert.equal(answer.source, "ring");
    assert.equal(answer.evidence.length, 2);
    const briefing = await ask("What did Ring record?", s, now);
    assert.match(briefing.text, /1 live-view request/);
    assert.match(briefing.text, /does not establish motion or a visitor/);
    assert.doesNotMatch(briefing.text, /1 probable visit/);
    assert.doesNotMatch(briefingFacts(s, "2026-09-29", zone)[0].text, /live-view request/);
    assert.doesNotMatch(visitFact(s, { ...e, expectedDate: "2026-09-29" }, zone).text, /live-view request/);
    // Provider failure must surface, never return the fixture plumber visit.
    await assert.rejects(syncRing((async () => new Response(null, { status: 401 })) as typeof fetch, "expired"), /HTTP 401/);
    // Do not infer physical zones or silently ingest a different account's devices.
    await assert.rejects(syncRing((async () => Response.json({ data: [1, 2].map(id => ({ type: "devices", id: String(id), attributes: { name: "camera" } })) })) as typeof fetch, "test"), /exactly one test device/);
  } finally {
    db.close();
    for (const [k, v] of Object.entries(previous)) { if (v === undefined) delete process.env[k]; else process.env[k] = v; }
  }
});

test("live views cannot bridge detections or change arrival and departure estimates", () => {
  const events = fixtureEvents(day, zone);
  const view = { ...events[0], id: "view", externalEventId: "view", eventType: "live_view" as const, occurredAt: `${day}T14:00:00.000Z` };
  const original = stitch(events, fixtureDevices, zone);
  const combined = stitch([view, ...events, { ...view, id: "later-view", occurredAt: `${day}T16:00:00.000Z` }], fixtureDevices, zone);
  assert.deepEqual(combined.filter(a => a.type !== "live_view"), original);
  const separated = stitch([events[0], { ...view, occurredAt: `${day}T15:20:00.000Z` }, { ...events[1], occurredAt: `${day}T16:00:00.000Z` }], fixtureDevices, zone);
  assert.equal(separated.some(a => a.type === "visit"), false);
  // Even a subtype-filter response cannot turn on_demand into a vehicle/person.
  assert.equal(normalizeHistory(row, { ...fixtureDevices[0], externalDeviceId: "sandbox-camera" }, "motion.vehicle")?.eventType, "live_view");
});

test("an explicitly reused database cannot mix Playground and configured-device evidence", () => {
  const folder = mkdtempSync(join(tmpdir(), "around-source-test-")), path = join(folder, "test.sqlite");
  try {
    new Store(path, "ring", zone, "playground").close();
    assert.throws(() => new Store(path, "ring", zone, "configured"), /source setup/);
    new Store(path, "ring", zone, "playground").close();
  } finally { rmSync(folder, { recursive: true, force: true }); }
});
