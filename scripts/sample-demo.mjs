import { spawn } from "node:child_process";
import { randomUUID } from "node:crypto";
import { createRequire } from "node:module";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const args = process.argv.slice(2);
if (args.some(arg => arg !== "--bedrock") || args.length > 1) {
  throw new Error("Usage: npm run demo:sample [-- --bedrock]");
}
const port = process.env.AROUND_DEMO_PORT || "3001";
if (!/^\d+$/.test(port) || Number(port) < 1024 || Number(port) > 65535) {
  throw new Error("AROUND_DEMO_PORT must be a port between 1024 and 65535.");
}
const root = dirname(dirname(fileURLToPath(import.meta.url)));
const database = join(root, "data", `sample-demo-${Date.now()}-${randomUUID().slice(0, 8)}.sqlite`);
const bedrock = args.includes("--bedrock");
console.log(`Sample activity demo: http://127.0.0.1:${port}`);
console.log(`New rehearsal database: ${database}`);
console.log(bedrock ? "Amazon Bedrock enabled. Supply an authorized key before using Tell or Ask." : "Local demo answers. No cloud inference is used.");
const child = spawn(process.execPath, [createRequire(import.meta.url).resolve("next/dist/bin/next"), "start", "--hostname", "127.0.0.1", "--port", port], {
  cwd: root,
  stdio: "inherit",
  env: { ...process.env, RING_MODE: "fixture", RING_DEVICE_MODE: "configured", AI_MODE: bedrock ? "bedrock" : "fixture", AROUND_DB_PATH: database },
});
for (const signal of ["SIGINT", "SIGTERM"]) process.once(signal, () => child.kill(signal));
child.once("error", error => { console.error(`Could not start sample demo: ${error.message}`); process.exitCode = 1; });
child.once("exit", code => { process.exitCode = code ?? 0; });
