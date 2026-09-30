import { NextResponse } from "next/server";
import { z } from "zod";
import { store } from "@/lib/db";
import { config } from "@/lib/config";
import { dayAt } from "@/lib/time";
import { fixtureDevices, fixtureEvents } from "@/lib/ring/fixture";
import { syncRing } from "@/lib/ring/api";
import { bodyText, errorResponse, localRequest } from "@/lib/http";
export const runtime = "nodejs";
export async function POST(request: Request) {
  try {
    localRequest(request); const c = config();
    // The optional token lives only for this request. Never store or return it.
    const { accessToken } = z.object({ accessToken: z.string().trim().min(1).max(16000).optional() }).parse(JSON.parse(await bodyText(request)));
    const data = c.ringMode === "fixture" ? { devices: fixtureDevices, events: fixtureEvents(dayAt(new Date(), c.timeZone), c.timeZone) } : await syncRing(fetch, accessToken);
    const changed = store().ingest(data.devices, data.events);
    return NextResponse.json({ changed, devices: data.devices.length, mode: c.ringMode }, { headers: { "Cache-Control": "no-store" } });
  } catch (error) { return errorResponse(error); }
}
