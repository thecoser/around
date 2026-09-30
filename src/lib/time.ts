import { formatInTimeZone, fromZonedTime } from "date-fns-tz";
export function dayAt(date = new Date(), zone = "America/New_York") { return formatInTimeZone(date, zone, "yyyy-MM-dd"); }
export function timeAt(value: string, zone: string) { return formatInTimeZone(value, zone, "h:mm a"); }
export function atLocal(day: string, time: string, zone: string) {
  const value = fromZonedTime(`${day}T${time}:00`, zone);
  if (!Number.isFinite(value.getTime()) || formatInTimeZone(value, zone, "yyyy-MM-dd'T'HH:mm") !== `${day}T${time}`) throw new Error("Invalid local date or time.");
  return value.toISOString();
}
