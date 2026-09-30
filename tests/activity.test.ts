import { test } from "node:test";
import assert from "node:assert/strict";
import { fixtureDevices, fixtureEvents } from "../src/lib/ring/fixture";
import { matchExpectations, stitch } from "../src/lib/activity";
import { atLocal } from "../src/lib/time";
import { briefingFacts, validateExpectation, validateFactSelection, visitFact } from "../src/lib/ai";
import { Store } from "../src/lib/db";
const zone = "America/New_York", day = "2026-09-28";
const expectation = () => validateExpectation({ personOrService: "plumber", expectedDate: day, startWindow: "10:00", endWindow: "13:00", location: "Home" }, "The plumber is coming today between 10 and 1.", zone);
test("four moments group into one visit, persisted and matched with grounded times", () => {
  const db = new Store(":memory:", "fixture", zone);
  try {
    const e = expectation(); db.saveExpectation(e);
    assert.equal(db.ingest(fixtureDevices, fixtureEvents(day, zone)), 4);
    const s = db.snapshot(); assert.equal(s.activities.length, 1); assert.equal(s.matches.length, 1);
    assert.equal(s.activities[0].eventIds.length, 4); assert.equal(s.expectations[0].status, "likely_match");
    const fact = visitFact(s, e, zone);
    assert.match(fact.text, /10:41 AM/); assert.match(fact.text, /11:27 AM/); assert.match(fact.text, /can't confirm who/);
    assert.equal(db.ingest(fixtureDevices, fixtureEvents(day, zone)), 0);
    assert.equal(db.snapshot().events.length, 4);
  } finally { db.close(); }
});
test("late and duplicate events group deterministically regardless of delivery order", () => {
  const events = fixtureEvents(day, zone);
  assert.deepEqual(stitch([...events].reverse().concat(events[0]), fixtureDevices, zone), stitch(events, fixtureDevices, zone));
});
test("expectation entered after activity still matches", () => {
  const db = new Store(":memory:", "fixture", zone);
  try { db.ingest(fixtureDevices, fixtureEvents(day, zone)); db.saveExpectation(expectation()); assert.equal(db.snapshot().matches.length, 1); } finally { db.close(); }
});
test("vehicle alone and unclassified motion do not establish a visit", () => {
  const events = fixtureEvents(day, zone);
  assert.equal(stitch([events[0]], fixtureDevices, zone)[0].type, "activity");
  assert.equal(stitch(events.map(e => ({ ...e, eventType: "motion" })), fixtureDevices, zone)[0].type, "activity");
});
test("unfinished visit has no departure estimate", () => {
  const a = stitch(fixtureEvents(day, zone).slice(0, 2), fixtureDevices, zone)[0];
  assert.equal(a.type, "visit"); assert.equal(a.endedAt, null);
});
test("ordinary Ring vehicle observations yield qualified visit boundaries", () => {
  const events = fixtureEvents(day, zone).map(e => ({ ...e, source: "ring" as const, eventType: e.eventType.startsWith("vehicle") ? "vehicle" as const : e.eventType }));
  const activities = stitch(events, fixtureDevices, zone);
  assert.equal(activities.length, 1); assert.equal(activities[0].type, "visit");
  assert.equal(activities[0].endedAt, atLocal(day, "11:27", zone));
  assert.equal(matchExpectations([expectation()], activities, zone).length, 1);
});
test("60 minute gap, other homes, and different days prevent inappropriate grouping", () => {
  const events = fixtureEvents(day, zone);
  assert.equal(stitch([events[0], { ...events[1], occurredAt: atLocal(day, "12:00", zone) }], fixtureDevices, zone).length, 2);
  assert.equal(stitch(events, fixtureDevices.map(d => ({ ...d, locationName: d.zone === "front_door" ? "Other home" : "Home" })), zone).some(a => a.type === "visit"), false);
  assert.equal(stitch([events[0], { ...events[1], occurredAt: atLocal("2026-09-29", "10:43", zone) }], fixtureDevices, zone).length, 2);
});
test("arrival outside window does not match; boundary is inclusive", () => {
  const activities = stitch(fixtureEvents(day, zone), fixtureDevices, zone), e = expectation();
  assert.equal(matchExpectations([{ ...e, startWindow: "11:00" }], activities, zone).length, 0);
  assert.equal(matchExpectations([{ ...e, endWindow: "10:41" }], activities, zone).length, 1);
  assert.equal(matchExpectations([{ ...e, expectedDate: "2026-09-29" }], activities, zone).length, 0);
});
test("overlapping expectations and competing visits stay ambiguous", () => {
  const e = expectation(), activities = stitch(fixtureEvents(day, zone), fixtureDevices, zone);
  assert.ok(matchExpectations([e, { ...e, id: "other", personOrService: "electrician" }], activities, zone).every(m => m.confidence < 0.6));
  assert.ok(matchExpectations([e], [...activities, { ...activities[0], id: "second" }], zone).every(m => m.confidence < 0.6));
});
test("absence of evidence never confirms a visit or absence; briefing excludes old dates", () => {
  const db = new Store(":memory:", "fixture", zone);
  try {
    const e = expectation(); db.saveExpectation(e);
    assert.match(visitFact(db.snapshot(), e, zone).text, /does not prove they did not come/);
    db.ingest(fixtureDevices, fixtureEvents(day, zone));
    const facts = briefingFacts(db.snapshot(), "2026-09-29", zone);
    assert.match(facts[0].text, /No activity/); assert.equal(facts.length, 2);
  } finally { db.close(); }
});
test("invalid time, date, reversed windows and DST gaps are rejected", () => {
  assert.throws(() => atLocal("2026-02-30", "10:00", zone));
  assert.throws(() => atLocal("2026-03-08", "02:30", zone));
  assert.equal(atLocal("2026-11-15", "10:00", zone), "2026-11-15T15:00:00.000Z");
  assert.throws(() => validateExpectation({ ...expectation(), startWindow: "18:00" }, "invalid", zone));
});
test("untrusted answer output cannot introduce claims or drop the required fact", () => {
  const facts = [{ id: "real", text: "No activity recorded.", evidence: [] }];
  assert.throws(() => validateFactSelection({ factIds: ["invented"] }, facts));
  assert.throws(() => validateFactSelection({ factIds: [] }, facts));
  assert.throws(() => validateFactSelection({ factIds: ["real", "real"] }, facts));
  assert.equal(validateFactSelection({ factIds: ["real"], inventedProse: "A visitor came." }, facts)[0].text, "No activity recorded.");
});
test("ingest failure rolls back events, devices and receipt", () => {
  const db = new Store(":memory:", "fixture", zone);
  try { assert.throws(() => db.ingest(fixtureDevices, fixtureEvents(day, zone).map(e => ({ ...e, source: "ring" })), "receipt")); assert.equal(db.snapshot().devices.length, 0); assert.equal(db.snapshot().events.length, 0); } finally { db.close(); }
});
