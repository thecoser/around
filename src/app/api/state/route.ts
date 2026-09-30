import { NextResponse } from "next/server";
import { store } from "@/lib/db";
import { config } from "@/lib/config";
import { dayAt } from "@/lib/time";
import { briefingFacts } from "@/lib/ai";
import { errorResponse, localRequest } from "@/lib/http";
export const runtime = "nodejs";
export const dynamic = "force-dynamic";
export async function GET(request: Request) {
  try {
    localRequest(request);
    const c = config(), s = store().snapshot(), today = dayAt(new Date(), c.timeZone);
    return NextResponse.json({ ...s, events: undefined, config: { ringMode: c.ringMode, ringDeviceMode: c.ringDeviceMode, aiMode: c.aiMode, timeZone: c.timeZone }, today, briefing: briefingFacts(s, today, c.timeZone).map(f => f.text).join(" ") }, { headers: { "Cache-Control": "no-store" } });
  } catch (error) { return errorResponse(error); }
}
