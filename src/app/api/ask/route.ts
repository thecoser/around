import { NextResponse } from "next/server";
import { ask, languageRequest } from "@/lib/ai";
import { store } from "@/lib/db";
import { bodyText, errorResponse, localRequest } from "@/lib/http";
export const runtime = "nodejs";
export async function POST(request: Request) {
  try { localRequest(request); const { text, bedrockToken } = languageRequest.parse(JSON.parse(await bodyText(request))); return NextResponse.json(await ask(text, store().snapshot(), new Date(), bedrockToken), { headers: { "Cache-Control": "no-store" } }); }
  catch (error) { return errorResponse(error); }
}
