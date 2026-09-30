import { test } from "node:test";
import assert from "node:assert/strict";
import { localRequest } from "../src/lib/http";
test("canonicalized Next URL accepts the browser's validated local Host and Origin", () => {
  assert.doesNotThrow(() => localRequest(new Request("http://localhost:3100/api/ask", { headers: { host: "127.0.0.1:3100", origin: "http://127.0.0.1:3100" } })));
  assert.throws(() => localRequest(new Request("http://localhost:3100/api/ask", { headers: { host: "127.0.0.1:3100", origin: "https://attacker.invalid" } })));
  assert.throws(() => localRequest(new Request("http://localhost:3100/api/ask", { headers: { host: "127.0.0.1:3100", origin: "http://127.0.0.1:4000" } })));
  assert.throws(() => localRequest(new Request("http://localhost:3100/api/ask", { headers: { host: "attacker.invalid" } })));
});
