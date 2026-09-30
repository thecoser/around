import { defineConfig, devices } from "@playwright/test";
export default defineConfig({
  testDir: "./tests/e2e", fullyParallel: false, workers: 1,
  use: { baseURL: "http://127.0.0.1:3100", trace: "retain-on-failure" },
  projects: [
    { name: "fixture", testMatch: "demo.spec.ts", use: { ...devices["Desktop Chrome"] } },
    { name: "playground-contract", testMatch: "playground.spec.ts", use: { ...devices["Desktop Chrome"], baseURL: "http://127.0.0.1:3101" } },
  ],
  webServer: [
    { command: "npm run demo:sample", url: "http://127.0.0.1:3100", reuseExistingServer: false, timeout: 60_000,
      env: { AROUND_DEMO_PORT: "3100", RING_MODE: "ring", AI_MODE: "bedrock", AROUND_TIME_ZONE: "America/New_York" } },
    { command: "node --import tsx tests/seed-playground.ts && npm run start -- --port 3101", url: "http://127.0.0.1:3101", reuseExistingServer: false, timeout: 60_000,
      env: { RING_MODE: "ring", RING_DEVICE_MODE: "playground", AI_MODE: "fixture", RING_ACCESS_TOKEN: "", AROUND_TIME_ZONE: "America/New_York", AROUND_DB_PATH: `/private/tmp/around-playground-contract-${Date.now()}.sqlite` } },
  ],
});
