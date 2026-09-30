import { test } from "node:test";
import assert from "node:assert/strict";
import { safeRingError } from "../src/lib/ring/errors";
import { syncRing } from "../src/lib/ring/api";
import { Store } from "../src/lib/db";
import { fixtureDevices, fixtureEvents } from "../src/lib/ring/fixture";

test("Ring diagnostics expose bounded categories without raw error details", () => {
  const secret = "private-token-and-provider-payload";
  const cases: [unknown, string][] = [
    [new DOMException(secret, "TimeoutError"), "timed out"],
    [new TypeError(secret, { cause: Object.assign(new Error(secret), { code: "ENOTFOUND" }) }), "ENOTFOUND"],
    [Object.assign(new Error(secret), { code: "ERR_TLS_CERT_ALTNAME_INVALID" }), "ERR_TLS_CERT_ALTNAME_INVALID"],
    [Object.assign(new Error(secret), { code: secret }), "unclassified failure"],
    [new SyntaxError(secret), "invalid JSON response"],
  ];
  for (const [error, expected] of cases) {
    const result = safeRingError(error, "device discovery");
    assert.ok(result.message.includes(expected));
    assert.ok(result.message.includes("device discovery"));
    assert.ok(!JSON.stringify(result).includes(secret));
    assert.ok(!result.message.includes(secret));
    assert.equal(result.cause, undefined);
    assert.equal(result.status, 502);
  }
  const cycle: { cause?: unknown } = {}; cycle.cause = cycle;
  assert.match(safeRingError(cycle, "local storage").message, /local storage \(unclassified failure\)/);
});

test("Ring sync failures identify their phase, never retry or ingest partial history", async () => {
  const prior = process.env.RING_DEVICE_MODE;
  process.env.RING_DEVICE_MODE = "playground";
  const store = new Store(":memory:", "ring", "America/New_York", "playground");
  const device = { id: "test-device", type: "devices", attributes: { name: "Test camera" } };
  try {
    let calls = 0;
    const fetcher = (async () => {
      calls++;
      if (calls === 1) return Response.json({ data: [device] });
      if (calls === 2) return Response.json({ data: [{ id: "test-event", type: "history-events", attributes: { event_type: "on_demand", start: 1790606580000 }, relationships: { source: { data: { id: "test-device", type: "devices" } } } }], links: { next: "/v1/history/devices/test-device/events?page=2" } });
      throw new TypeError("private request details", { cause: Object.assign(new Error("private token"), { code: "ECONNRESET" }) });
    }) as typeof fetch;
    await assert.rejects(async () => {
      const result = await syncRing(fetcher, "synthetic-test-token");
      store.ingest(result.devices, result.events);
    }, /event history \(ECONNRESET\)/);
    assert.equal(calls, 3);
    assert.equal(store.snapshot().events.length, 0);
    assert.equal(store.snapshot().devices.length, 0);
    calls = 0;
    await assert.rejects(syncRing((async () => { calls++; throw new DOMException("private details", "TimeoutError"); }) as typeof fetch, "synthetic-test-token"), /device discovery.*timed out/);
    assert.equal(calls, 1);
    await assert.rejects(syncRing((async () => { calls++; return Response.json({ data: [] }); }) as typeof fetch, "synthetic\nheader"), /No request was sent/);
    assert.equal(calls, 1);
    await assert.rejects(syncRing((async () => new Response("private invalid JSON")) as typeof fetch, "synthetic-test-token"), /device discovery \(invalid JSON response\)/);
    calls = 0;
    await assert.rejects(syncRing((async () => {
      calls++;
      return new Response(new ReadableStream({ start(controller) {
        controller.error(Object.assign(new Error("private body details"), { code: "UND_ERR_BODY_TIMEOUT" }));
      } }));
    }) as typeof fetch, "synthetic-test-token"), /device discovery \(UND_ERR_BODY_TIMEOUT\)/);
    assert.equal(calls, 1);
    await assert.rejects(syncRing((async () => Response.json({ data: "private invalid payload" })) as typeof fetch, "synthetic-test-token"), /device discovery \(unexpected response format\)/);
    await assert.rejects(syncRing((async () => new Response("private unauthorized response", { status: 401 })) as typeof fetch, "synthetic-test-token"), /HTTP 401/);
  } finally {
    store.close();
    if (prior === undefined) delete process.env.RING_DEVICE_MODE; else process.env.RING_DEVICE_MODE = prior;
  }
});

test("storage failure after an event insert rolls back the whole sync and redacts details", () => {
  const store = new Store(":memory:", "ring", "America/New_York", "playground");
  try {
    store.db.exec(`CREATE TRIGGER fail_second_event BEFORE INSERT ON RingEvent
      WHEN (SELECT count(*) FROM RingEvent) = 1
      BEGIN SELECT RAISE(ABORT, 'private storage details'); END;`);
    assert.throws(() => store.ingest(fixtureDevices, fixtureEvents("2026-09-30", "America/New_York").map(e => ({ ...e, source: "ring" }))), error => {
      const result = safeRingError(error, "local storage");
      assert.equal(result.status, 500);
      assert.match(result.message, /local storage \(ERR_SQLITE_ERROR\)/);
      assert.doesNotMatch(result.message, /private storage details/);
      return true;
    });
    assert.equal(store.snapshot().devices.length, 0);
    assert.equal(store.snapshot().events.length, 0);
    assert.equal(store.snapshot().activities.length, 0);
  } finally { store.close(); }
});
