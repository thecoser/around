import { test } from "node:test";
import assert from "node:assert/strict";
import { createHmac } from "node:crypto";
import { normalizeHistory, normalizeWebhook, ringUrl, syncRing, verifySignature } from "../src/lib/ring/api";
import type { RingDevice } from "../src/lib/types";
import { Store } from "../src/lib/db";
const device: RingDevice = { id: "ring:front", externalDeviceId: "front", name: "Front door", locationName: "Home", deviceType: "camera", zone: "front_door" };
const payload = { meta: { request_id: "request-1", account_id: "account-1" }, data: { type: "motion_detected", id: "event-1", attributes: { source: "front", source_type: "devices", timestamp: 1790606580000, sub_type: "human" } } };
test("official webhook nested subtype and epoch milliseconds normalize correctly", () => {
  const result = normalizeWebhook(payload, [device], "account-1");
  assert.equal(result.event?.eventType, "person"); assert.equal(result.event?.occurredAt, new Date(1790606580000).toISOString());
  assert.throws(() => normalizeWebhook(payload, [device], "other-account"));
  assert.throws(() => normalizeWebhook(payload, [], "account-1"));
});
test("raw body HMAC verification rejects tampering and malformed signatures", () => {
  const body = JSON.stringify(payload), key = "test-only-key";
  const signature = createHmac("sha256", key).update(body).digest("hex");
  assert.equal(verifySignature(body, `sha256=${signature}`, key), true);
  assert.equal(verifySignature(body + " ", signature, key), false);
  assert.equal(verifySignature(body, "short", key), false);
});
test("history normalization uses relationship source and preserves live views separately", () => {
  const row = { type: "history-events", id: "event", attributes: { event_type: "motion.vehicle", start: 1790606580000 }, relationships: { source: { data: { type: "devices", id: "front" } } } };
  assert.equal(normalizeHistory(row, device)?.eventType, "vehicle");
  assert.equal(normalizeHistory({ ...row, attributes: { ...row.attributes, event_type: "on_demand" } }, device)?.eventType, "live_view");
  assert.throws(() => normalizeHistory(row, { ...device, externalDeviceId: "other" }));
});
test("pagination cannot forward a Ring credential to another origin", () => {
  assert.throws(() => ringUrl("https://attacker.invalid/v1/devices"));
  assert.throws(() => ringUrl("//attacker.invalid/v1/devices"));
  assert.equal(ringUrl("/v1/devices").origin, "https://api.amazonvision.com");
});
test("API adapter calls official discovery and per-device history, including pagination", async () => {
  const previous = { token: process.env.RING_ACCESS_TOKEN, driveway: process.env.RING_DRIVEWAY_DEVICE_ID, front: process.env.RING_FRONT_DOOR_DEVICE_ID };
  process.env.RING_ACCESS_TOKEN = "test-only"; process.env.RING_DRIVEWAY_DEVICE_ID = "drive"; process.env.RING_FRONT_DOOR_DEVICE_ID = "front";
  const calls: string[] = [];
  const fetcher = (async (input: URL | RequestInfo, init?: RequestInit) => {
    const url = new URL(String(input)); calls.push(url.href); assert.equal((init?.headers as Record<string,string>).Authorization, "Bearer test-only");
    if (url.pathname === "/v1/devices") return Response.json({ data: ["drive", "front"].map(id => ({ id, type: "devices", attributes: { name: id } })) });
    if (url.searchParams.has("page[key]")) return Response.json({ data: [], links: { next: url.pathname + "?page[key]=empty" } });
    const id = url.pathname.split("/")[4];
    return Response.json({ data: [{ id: `${id}-event`, type: "history-events", attributes: { event_type: id === "drive" ? "motion.vehicle" : "motion.human", start: 1790606580000 }, relationships: { source: { data: { id, type: "devices" } } } }], links: { next: `${url.pathname}?page[key]=next` } });
  }) as typeof fetch;
  try {
    const data = await syncRing(fetcher); assert.equal(data.devices.length, 2); assert.equal(data.events.length, 4); assert.equal(calls.length, 9);
    await assert.rejects(syncRing((async () => new Response("expired", { status: 401 })) as typeof fetch), /HTTP 401/);
  } finally { for (const [key, value] of [["RING_ACCESS_TOKEN", previous.token], ["RING_DRIVEWAY_DEVICE_ID", previous.driveway], ["RING_FRONT_DOOR_DEVICE_ID", previous.front]]) { if (value === undefined) delete process.env[key!]; else process.env[key!] = value; } }
});
test("webhook retry remains idempotent and enriches a generic history event", () => {
  const db = new Store(":memory:", "ring", "America/New_York");
  try {
    const result = normalizeWebhook(payload, [device], "account-1"), event = result.event!;
    db.ingest([device], [{ ...event, eventType: "motion" }]);
    assert.equal(db.ingest([], [event], result.requestId), 1);
    assert.equal(db.ingest([], [event], result.requestId), 0);
    assert.equal(db.snapshot().events.length, 1); assert.equal(db.snapshot().events[0].eventType, "person");
  } finally { db.close(); }
});
test("a dedicated server subtype filter can classify a generic motion history row", () => {
  const row = { type: "history-events", id: "vehicle-event", attributes: { event_type: "motion", start: 1790606580000 }, relationships: { source: { data: { type: "devices", id: "front" } } } };
  assert.equal(normalizeHistory(row, device)?.eventType, "motion");
  assert.equal(normalizeHistory(row, device, "motion.vehicle")?.eventType, "vehicle");
});
