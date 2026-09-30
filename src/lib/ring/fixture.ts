import { atLocal } from "../time";
import type { RingDevice, RingEvent } from "../types";
export const fixtureDevices: RingDevice[] = [
  { id: "fixture-driveway", externalDeviceId: "fixture-driveway", name: "Driveway", locationName: "Home", deviceType: "camera", zone: "driveway" },
  { id: "fixture-front-door", externalDeviceId: "fixture-front-door", name: "Front door", locationName: "Home", deviceType: "doorbell", zone: "front_door" },
];
export function fixtureEvents(day: string, zone: string): RingEvent[] {
  return ([
    ["10:41", "fixture-driveway", "vehicle_arrival"], ["10:43", "fixture-front-door", "person"],
    ["11:25", "fixture-front-door", "motion"], ["11:27", "fixture-driveway", "vehicle_departure"],
  ] as const).map(([time, deviceId, eventType], i) => ({
    id: `fixture:${day}:${i}`, externalEventId: `${day}:${i}`, deviceId, eventType,
    occurredAt: atLocal(day, time, zone), rawPayload: JSON.stringify({ fixture: "plumber-visit-v1", day, time, eventType }), source: "fixture",
  }));
}
