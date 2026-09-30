import { Readable } from "node:stream";
import { test } from "node:test";
import assert from "node:assert/strict";
import { BedrockRuntimeClient } from "@aws-sdk/client-bedrock-runtime";
import { ask, bedrockJson, languageRequest, parseExpectation, safeBedrockError } from "../src/lib/ai";
import { Store } from "../src/lib/db";
import { fixtureDevices, fixtureEvents } from "../src/lib/ring/fixture";

const token = "synthetic-bedrock-test-key";
test("Bedrock key authenticates parsing and grounded answers without entering prompts or stored records", async t => {
  const values = { AI_MODE: "bedrock", RING_MODE: "fixture", AWS_REGION: "us-east-1", BEDROCK_MODEL_ID: "amazon.nova-micro-v1:0", AROUND_TIME_ZONE: "America/New_York" };
  const previous = Object.fromEntries(Object.keys(values).map(k => [k, process.env[k]]));
  Object.assign(process.env, values);
  const db = new Store(":memory:", "fixture", values.AROUND_TIME_ZONE);
  let calls = 0;
  let expectationId = "";
  const originalSend = BedrockRuntimeClient.prototype.send;
  t.mock.method(BedrockRuntimeClient.prototype, "send", async function (this: BedrockRuntimeClient, command: { input: unknown }) {
    calls++;
    assert.equal((await this.config.token!()).token, token);
    assert.deepEqual(await this.config.authSchemePreference!(), ["httpBearerAuth"]);
    assert.equal(JSON.stringify(command.input).includes(token), false);
    const response = calls === 1 ? { personOrService: "plumber", expectedDate: "2026-09-28", startWindow: "10:00", endWindow: "13:00", location: "Home" }
      : calls === 2 ? { kind: "visit", expectationId } : { factIds: [expectationId] };
    return { output: { message: { content: [{ text: JSON.stringify(response) }] } } };
  });
  try {
    const now = new Date("2026-09-28T18:00:00Z");
    const expectation = await parseExpectation("The plumber is coming today between 10 and 1.", now, token);
    expectationId = expectation.id;
    db.saveExpectation(expectation);
    db.ingest(fixtureDevices, fixtureEvents("2026-09-28", values.AROUND_TIME_ZONE));
    const answer = await ask("Did the plumber come?", db.snapshot(), now, token);
    assert.equal(calls, 3);
    assert.equal(answer.engine, "bedrock");
    assert.match(answer.text, /10:41 AM/);
    assert.match(answer.text, /11:27 AM/);
    assert.match(answer.text, /can't confirm who visited/);
    assert.equal(JSON.stringify({ answer, snapshot: db.snapshot() }).includes(token), false);
    await assert.rejects(bedrockJson("test", "x".repeat(12001), token), /too much saved context/);
    assert.equal(calls, 3);
    t.mock.method(BedrockRuntimeClient.prototype, "send", async () => { throw new Error(`provider detail ${token}`); });
    await assert.rejects(parseExpectation("The plumber is coming today between 10 and 1.", now, token), error => {
      assert.match(String(error), /No local fallback was used/);
      assert.equal(String(error).includes(token), false);
      return true;
    });
    // Exercise actual SDK serialization/auth middleware, replacing only transport.
    t.mock.method(BedrockRuntimeClient.prototype, "send", function (this: BedrockRuntimeClient, ...args: Parameters<typeof originalSend>) {
      this.config.requestHandler = { handle: async request => {
        assert.equal(request.hostname, "bedrock-runtime.us-east-1.amazonaws.com");
        assert.equal(request.headers.Authorization || request.headers.authorization, `Bearer ${token}`);
        const body = typeof request.body === "string" ? request.body : new TextDecoder().decode(request.body);
        assert.equal(body.includes(token), false);
        return { response: { statusCode: 200, headers: { "content-type": "application/json" }, body: Readable.from([JSON.stringify({ output: { message: { role: "assistant", content: [{ text: '{"ok":true}' }] } } })]) } };
      } };
      return originalSend.apply(this, args);
    });
    assert.deepEqual(await bedrockJson("Return ok", { text: "Synthetic test" }, token), { ok: true });
    assert.equal(languageRequest.safeParse({ text: "Hello", bedrockToken: "x".repeat(16001) }).success, false);
  } finally {
    db.close();
    for (const [k, v] of Object.entries(previous)) { if (v === undefined) delete process.env[k]; else process.env[k] = v; }
  }
});


test("Bedrock diagnostics expose only allowlisted categories and HTTP status", () => {
  const denied = Object.assign(new Error("private provider details synthetic-secret"), { name: "AccessDeniedException", $metadata: { httpStatusCode: 403 } });
  assert.match(safeBedrockError(denied).message, /AccessDeniedException, HTTP 403/);
  assert.doesNotMatch(safeBedrockError(denied).message, /private|synthetic-secret/);
  assert.match(safeBedrockError(new SyntaxError("private output")).message, /invalid model JSON/);
  assert.match(safeBedrockError(Object.assign(new Error(), { name: "AbortError" })).message, /timed out/);
  assert.match(safeBedrockError(Object.assign(new Error(), { name: "secret-as-error-name" })).message, /unclassified request failure/);
  assert.doesNotMatch(safeBedrockError(Object.assign(new Error(), { name: "secret-as-error-name" })).message, /secret-as-error-name/);
});

test("provider access reasons become fixed labels without echoing private details", () => {
  for (const [message, expected] of [
    ["Your account is currently being verified. private-secret", "account verification is pending"],
    ["User private-secret cannot bedrock:CallWithBearerToken", "bearer-token authentication"],
    ["User private-secret cannot bedrock:InvokeModel", "permission to invoke"],
    ["Root identity private-secret denied", "root identity"],
    ["Invalid bearer token private-secret", "invalid or expired credential"],
  ]) {
    const error = Object.assign(new Error(message), { name: "AccessDeniedException" });
    assert.ok(safeBedrockError(error).message.includes(expected));
    assert.doesNotMatch(safeBedrockError(error).message, /private-secret/);
  }
});

test("explicit briefing commands bypass intent classification and use today's facts", async t => {
  const values = { AI_MODE: "bedrock", RING_MODE: "fixture", AWS_REGION: "us-east-1", BEDROCK_MODEL_ID: "amazon.nova-micro-v1:0", AROUND_TIME_ZONE: "America/New_York" };
  const previous = Object.fromEntries(Object.keys(values).map(k => [k, process.env[k]]));
  Object.assign(process.env, values);
  const db = new Store(":memory:", "fixture", values.AROUND_TIME_ZONE);
  db.ingest(fixtureDevices, fixtureEvents("2026-09-28", values.AROUND_TIME_ZONE));
  let calls = 0;
  t.mock.method(BedrockRuntimeClient.prototype, "send", async (command: { input: { messages: { content: { text: string }[] }[] } }) => {
    calls++;
    const body = JSON.parse(command.input.messages[0].content[0].text);
    assert.ok(Array.isArray(body.facts), "The first and only call selects briefing facts, not an intent.");
    assert.equal(body.facts[0].id, "overview");
    assert.match(body.facts[0].text, /No activity is stored for today/);
    return { output: { message: { content: [{ text: JSON.stringify({ factIds: body.facts.map((f: { id: string }) => f.id) }) }] } } };
  });
  try {
    for (const question of ["Anything I should know?", "What did Ring record?"]) {
      const answer = await ask(question, db.snapshot(), new Date("2026-09-29T18:00:00Z"), token);
      assert.match(answer.text, /No activity is stored for today/);
      assert.doesNotMatch(answer.text, /10:41|11:27|looks like they did/);
      assert.equal(answer.engine, "bedrock");
    }
    assert.equal(calls, 2);
  } finally {
    db.close();
    for (const [k, v] of Object.entries(previous)) { if (v === undefined) delete process.env[k]; else process.env[k] = v; }
  }
});
