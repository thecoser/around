// Synthetic contract data for the browser test, never provider-execution proof.
import { Store } from "../src/lib/db";
import { normalizeHistory } from "../src/lib/ring/api";
import { atLocal, dayAt } from "../src/lib/time";
import type { RingDevice } from "../src/lib/types";
const path = process.env.AROUND_DB_PATH;
if (!path?.startsWith("/private/tmp/around-playground-contract-")) throw new Error("Only an isolated contract-test database can be seeded.");
const zone = "America/New_York", day = dayAt(new Date(), zone);
const db = new Store(path, "ring", zone, "playground");
try {
  const device: RingDevice = { id: "ring:contract-camera", externalDeviceId: "contract-camera", name: "Contract test camera", locationName: "Ring Playground", deviceType: "Ring camera", zone: "other" };
  const event = normalizeHistory({ type: "history-events", id: "contract-view", attributes: { event_type: "on_demand", start: Date.parse(atLocal(day, "10:41", zone)) }, relationships: { source: { data: { type: "devices", id: device.externalDeviceId } } } }, device)!;
  db.ingest([device], [event]);
} finally { db.close(); }
