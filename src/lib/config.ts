import { z } from "zod";
export function config() {
  const ringMode = z.enum(["fixture", "ring"]).parse(process.env.RING_MODE || "fixture");
  const aiMode = z.enum(["fixture", "bedrock"]).parse(process.env.AI_MODE || "fixture");
  const ringDeviceMode = z.enum(["configured", "playground"]).parse(process.env.RING_DEVICE_MODE || "configured");
  const timeZone = process.env.AROUND_TIME_ZONE || "America/New_York";
  new Intl.DateTimeFormat("en-US", { timeZone }).format();
  return { ringMode, ringDeviceMode, aiMode, timeZone, dbPath: process.env.AROUND_DB_PATH || `data/around-${ringMode}${ringMode === "ring" ? `-${ringDeviceMode}` : ""}.sqlite` };
}
export class AppError extends Error {
  constructor(message: string, public status = 400) { super(message); }
}
export function required(name: string) {
  const value = process.env[name];
  if (!value) throw new AppError(`${name} is not configured. See README setup instructions.`, 503);
  return value;
}
