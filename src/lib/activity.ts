import { createHash } from "node:crypto";
import type { Activity, Expectation, ExpectationMatch, RingDevice, RingEvent } from "./types";
import { atLocal, dayAt } from "./time";

// One home's short visit, with at most 60 minutes of silence and 3 hours total.
// These are grouping heuristics, never identity or continuous-presence evidence.
export function stitch(events: RingEvent[], devices: RingDevice[], zone: string): Activity[] {
  const lookup = new Map(devices.map(d => [d.id, d]));
  const unique = [...new Map(events.map(e => [e.id, e])).values()].sort((a, b) => a.occurredAt.localeCompare(b.occurredAt) || a.id.localeCompare(b.id));
  const groups: RingEvent[][] = [];
  for (const event of unique) {
    const device = lookup.get(event.deviceId);
    if (!device) continue;
    const group = groups.findLast(g => {
      const first = g[0], last = g[g.length - 1];
      // Opening a stream is never detection evidence and must not bridge visits.
      return event.eventType !== "live_view" && first.eventType !== "live_view"
        && first.source === event.source && lookup.get(first.deviceId)?.locationName === device.locationName
        && dayAt(new Date(first.occurredAt), zone) === dayAt(new Date(event.occurredAt), zone)
        && Date.parse(event.occurredAt) - Date.parse(last.occurredAt) <= 60 * 60_000
        && Date.parse(event.occurredAt) - Date.parse(first.occurredAt) <= 3 * 60 * 60_000
        && last.eventType !== "vehicle_departure" && event.eventType !== "vehicle_arrival";
    });
    if (group) group.push(event); else groups.push([event]);
  }
  return groups.map(g => {
    const first = g[0], last = g[g.length - 1];
    const liveView = first.eventType === "live_view";
    const driveway = g.some(e => lookup.get(e.deviceId)?.zone === "driveway" && e.eventType.startsWith("vehicle"));
    const front = g.some(e => lookup.get(e.deviceId)?.zone === "front_door" && ["person", "doorbell"].includes(e.eventType));
    const visit = driveway && front;
    const lastAtDriveway = lookup.get(last.deviceId)?.zone === "driveway" && last.eventType.startsWith("vehicle") && last !== first;
    const hasEnd = visit && (last.eventType === "vehicle_departure" || lastAtDriveway);
    return {
      id: `activity-${createHash("sha256").update(first.id).digest("hex").slice(0, 20)}`,
      type: liveView ? "live_view" : visit ? "visit" : "activity", startedAt: first.occurredAt, endedAt: hasEnd ? last.occurredAt : null,
      label: liveView ? "Live view requested" : visit ? "Probable visit" : "Activity around your home", confidence: liveView ? 1 : visit ? 0.75 : 0.4,
      summary: liveView ? "Ring recorded a request to open a live view. This does not establish motion, a visitor, or successful video playback." : visit ? "Vehicle and front-door activity occurred close together. This may be one visit; who visited is not confirmed." : "Activity was recorded, but there is not enough evidence to call it a visit.",
      eventIds: g.map(e => e.id), locationName: lookup.get(first.deviceId)!.locationName, source: first.source,
    };
  });
}

export function matchExpectations(expectations: Expectation[], activities: Activity[], zone: string): ExpectationMatch[] {
  const candidates: ExpectationMatch[] = [];
  for (const expectation of expectations) {
    const start = atLocal(expectation.expectedDate, expectation.startWindow, zone);
    const end = atLocal(expectation.expectedDate, expectation.endWindow, zone);
    for (const activity of activities) {
      if (activity.type !== "visit" || activity.locationName.toLowerCase() !== expectation.location.toLowerCase()) continue;
      if (activity.startedAt < start || activity.startedAt > end) continue;
      candidates.push({ expectationId: expectation.id, activityId: activity.id, confidence: 0.7,
        explanation: "A probable visit began within the expected time window at this home. Timing suggests a connection; identity is unconfirmed." });
    }
  }
  return candidates.map(m => {
    const ambiguous = candidates.filter(c => c.expectationId === m.expectationId).length > 1 || candidates.filter(c => c.activityId === m.activityId).length > 1;
    return ambiguous ? { ...m, confidence: 0.4, explanation: "Several visits or expectations fit this window. The activity cannot be assigned to this expectation reliably." } : m;
  });
}
