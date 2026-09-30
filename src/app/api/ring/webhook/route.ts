import { NextResponse } from "next/server";
import { store } from "@/lib/db";
import { AppError, config, required } from "@/lib/config";
import { normalizeWebhook, verifySignature } from "@/lib/ring/api";
import { bodyText, errorResponse } from "@/lib/http";
export const runtime = "nodejs";
export async function POST(request: Request) {
  try {
    if (config().ringMode !== "ring") throw new AppError("Ring webhooks are disabled in fixture mode.", 409);
    const body = await bodyText(request);
    if (!verifySignature(body, request.headers.get("x-signature") || "", required("RING_HMAC_KEY"))) throw new AppError("Invalid Ring signature.", 401);
    const db = store(), payload = normalizeWebhook(JSON.parse(body), db.snapshot().devices, required("RING_ACCOUNT_ID"));
    // No model calls or network operations on webhook delivery.
    const changed = db.ingest([], payload.event ? [payload.event] : [], payload.requestId);
    return NextResponse.json({ received: true, changed });
  } catch (error) { return errorResponse(error); }
}
