import { NextResponse } from "next/server";
import { languageRequest, parseExpectation } from "@/lib/ai";
import { store } from "@/lib/db";
import { bodyText, errorResponse, localRequest } from "@/lib/http";
export const runtime = "nodejs";
export async function POST(request: Request) {
  try { localRequest(request); const { text, bedrockToken } = languageRequest.parse(JSON.parse(await bodyText(request))); const expectation = await parseExpectation(text, new Date(), bedrockToken); store().saveExpectation(expectation); return NextResponse.json({ expectation }, { status: 201, headers: { "Cache-Control": "no-store" } }); }
  catch (error) { return errorResponse(error); }
}
