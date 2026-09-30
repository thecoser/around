import { createHmac, timingSafeEqual } from "node:crypto";
import { z } from "zod";
import { AppError, config, required } from "../config";
import type { EventType, RingDevice, RingEvent } from "../types";
import { safeRingError } from "./errors";

const object = z.record(z.string(), z.unknown());
const resource = z.object({ id: z.string().min(1), type: z.string(), attributes: object, relationships: object.optional() });
const pageSchema = z.object({ data: z.array(resource), links: z.object({ next: z.string().nullable().optional() }).optional() });
const BASE = "https://api.amazonvision.com";
export function ringUrl(path: string) {
  const url = new URL(path, BASE);
  if (url.origin !== BASE || !url.pathname.startsWith("/v1/") || url.username || url.password) throw new AppError("Ring returned an invalid pagination link.", 502);
  return url;
}
async function pages(path: string, token: string, fetcher: typeof fetch = fetch) {
  const results: z.infer<typeof resource>[] = [];
  const seen = new Set<string>();
  let next: string | null | undefined = path;
  for (let count = 0; next; count++) {
    if (count >= 20 || seen.has(next)) throw new AppError("Ring history exceeded the bounded sync limit. No partial sync was saved.", 502);
    seen.add(next);
    const headers = { Authorization: `Bearer ${token}`, Accept: "application/vnd.api+json" };
    // Validate locally before fetch so a malformed pasted value is distinguishable
    // from a provider rejection. Keep the value out of all diagnostics.
    try { new Headers(headers); }
    catch { throw new AppError("The Ring token contains characters that cannot be sent in an HTTP header. Paste only the token. No request was sent.", 400); }
    let page: z.infer<typeof pageSchema>;
    try {
      const response = await fetcher(ringUrl(next), { headers, signal: AbortSignal.timeout(12_000), redirect: "error", cache: "no-store" });
      if (!response.ok) throw new AppError(`Ring returned HTTP ${response.status}. Check access, token expiry, and API setup. No fixture fallback was used.`, 502);
      page = pageSchema.parse(await response.json());
    } catch (error) {
      throw safeRingError(error, path === "/v1/devices" ? "device discovery" : "event history");
    }
    results.push(...page.data);
    // The reference explicitly permits empty pages with links.next. Stop on empty.
    next = page.data.length ? page.links?.next : null;
  }
  return results;
}
function normalizedType(value: string): EventType | null {
  if (value === "on_demand") return "live_view";
  if (["human", "motion.human"].includes(value)) return "person";
  if (["vehicle", "motion.vehicle"].includes(value)) return "vehicle";
  if (["ding", "button_press"].includes(value)) return "doorbell";
  if (["motion", "other_motion", "motion.other_motion"].includes(value)) return "motion";
  return null;
}
function timestamp(value: unknown) {
  const milliseconds = z.coerce.number().finite().positive().parse(value);
  const date = new Date(milliseconds);
  if (!Number.isFinite(date.getTime()) || date.getUTCFullYear() < 2000 || date.getUTCFullYear() > 2100) throw new AppError("Ring supplied an invalid event timestamp.", 502);
  return date.toISOString();
}
export function normalizeHistory(input: unknown, device: RingDevice, subtypeFilter?: "motion.human" | "motion.vehicle"): RingEvent | null {
  const item = resource.parse(input);
  const source = z.object({ source: z.object({ data: z.object({ id: z.string(), type: z.literal("devices") }) }) }).parse(item.relationships);
  if (source.source.data.id !== device.externalDeviceId) throw new AppError("Ring history device does not match its request.", 502);
  const reportedType = z.string().parse(item.attributes.event_type);
  // A generic motion row in a single-subtype query is classified by that
  // documented server filter, never by device position or an LLM guess.
  const eventType = normalizedType(reportedType === "motion" && subtypeFilter ? subtypeFilter : reportedType);
  if (!eventType) return null;
  return { id: `ring:${device.id}:${item.id}`, externalEventId: item.id, deviceId: device.id, eventType, occurredAt: timestamp(item.attributes.start), rawPayload: JSON.stringify(input), source: "ring" };
}
export function verifySignature(body: string, signature: string, key: string) {
  const hex = signature.replace(/^sha256=/, "");
  if (!/^[a-f0-9]{64}$/i.test(hex)) return false;
  return timingSafeEqual(createHmac("sha256", key).update(body).digest(), Buffer.from(hex, "hex"));
}
export function normalizeWebhook(input: unknown, devices: RingDevice[], expectedAccount: string) {
  const payload = z.object({ meta: z.object({ request_id: z.string().min(1), account_id: z.string() }), data: resource }).parse(input);
  if (payload.meta.account_id !== expectedAccount) throw new AppError("Ring account does not match this demo.", 403);
  const item = payload.data;
  // Lifecycle notifications are acknowledged, but never interpreted as visits.
  if (!["motion_detected", "button_press"].includes(item.type)) return { requestId: payload.meta.request_id, event: null };
  const device = devices.find(d => d.externalDeviceId === item.attributes.source);
  if (!device) throw new AppError("Ring device is not configured. Sync configured devices first.", 409);
  const eventType = normalizedType(item.type === "motion_detected" ? z.string().parse(item.attributes.sub_type) : item.type);
  const event: RingEvent | null = eventType ? { id: `ring:${device.id}:${item.id}`, externalEventId: item.id, deviceId: device.id, eventType, occurredAt: timestamp(item.attributes.timestamp), rawPayload: JSON.stringify(input), source: "ring" } : null;
  return { requestId: payload.meta.request_id, event };
}
export async function syncRing(fetcher: typeof fetch = fetch, accessToken?: string) {
  const token = accessToken || required("RING_ACCESS_TOKEN");
  const playground = config().ringDeviceMode === "playground";
  const driveway = playground ? undefined : required("RING_DRIVEWAY_DEVICE_ID");
  const front = playground ? undefined : required("RING_FRONT_DOOR_DEVICE_ID");
  if (!playground && driveway === front) throw new AppError("Configure distinct driveway and front-door Ring devices.", 503);
  const discovered = await pages("/v1/devices", token, fetcher);
  if (playground && discovered.length !== 1) throw new AppError("Playground setup expects exactly one test device. Check that you are using a Playground token. No data was saved.", 502);
  const ids = playground ? discovered.map(d => d.id) : [driveway!, front!];
  const devices: RingDevice[] = ids.map(id => {
    const found = discovered.find(d => d.id === id);
    if (!found) throw new AppError("A configured Ring device was not returned by discovery. Check authorization and directed device IDs.", 502);
    return { id: `ring:${id}`, externalDeviceId: id, name: z.string().parse(found.attributes.name), locationName: playground ? "Ring Playground" : "Home", deviceType: "Ring camera", zone: playground ? "other" : id === driveway ? "driveway" : "front_door" };
  });
  const events: RingEvent[] = [];
  for (const device of devices) {
    const subtype = device.zone === "driveway" ? "motion.vehicle" : "motion.human";
    for (const filter of playground ? [""] : ["motion,ding,on_demand", subtype]) {
      const history = await pages(`/v1/history/devices/${encodeURIComponent(device.externalDeviceId)}/events${filter ? `?event_types=${filter}` : ""}`, token, fetcher);
      for (const row of history) { const event = normalizeHistory(row, device, filter === subtype ? subtype : undefined); if (event) events.push(event); }
    }
  }
  return { devices, events };
}
