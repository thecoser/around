import { NextResponse } from "next/server";
import { ZodError } from "zod";
import { AppError } from "./config";
export function localRequest(request: Request) {
  const url = new URL(request.url), origin = request.headers.get("origin"), host = request.headers.get("host") || "";
  // Next can canonicalize request.url to localhost while the browser uses
  // 127.0.0.1. Compare Origin to the separately validated incoming Host.
  if (!/^(localhost|127\.0\.0\.1)(:\d+)?$/.test(host) || !["localhost", "127.0.0.1"].includes(url.hostname) || (origin && new URL(origin).origin !== `${url.protocol}//${host}`)) throw new AppError("This demo can only be used from its local address.", 403);
}
export async function bodyText(request: Request) {
  const reader = request.body?.getReader();
  if (!reader) throw new AppError("A request body is required.");
  const chunks: Uint8Array[] = []; let size = 0;
  while (true) { const { done, value } = await reader.read(); if (done) break; size += value.length; if (size > 64_000) { await reader.cancel(); throw new AppError("Request is too large.", 413); } chunks.push(value); }
  return Buffer.concat(chunks).toString("utf8");
}
export function errorResponse(error: unknown) {
  if (error instanceof AppError) return NextResponse.json({ error: error.message }, { status: error.status });
  if (error instanceof ZodError || error instanceof SyntaxError) return NextResponse.json({ error: "The supplied data has an invalid format. Check your input or provider setup." }, { status: 400 });
  return NextResponse.json({ error: "The request could not be completed. Check local configuration and try again." }, { status: 500 });
}
