import { ZodError } from "zod";
import { AppError } from "../config";

export type RingFailureStage = "device discovery" | "event history" | "response validation" | "local storage";

// Only fixed labels and allowlisted codes leave the server. Error messages,
// URLs, payloads and credentials must never be returned or logged here.
export function safeRingError(error: unknown, stage: RingFailureStage) {
  if (error instanceof AppError) return error;
  const codes = new Set([
    "ENOTFOUND", "EAI_AGAIN", "ECONNREFUSED", "ECONNRESET", "ENETUNREACH", "EHOSTUNREACH",
    "ETIMEDOUT", "UND_ERR_CONNECT_TIMEOUT", "UND_ERR_HEADERS_TIMEOUT", "UND_ERR_BODY_TIMEOUT",
    "UND_ERR_SOCKET", "CERT_HAS_EXPIRED", "CERT_NOT_YET_VALID", "UNABLE_TO_VERIFY_LEAF_SIGNATURE",
    "DEPTH_ZERO_SELF_SIGNED_CERT", "SELF_SIGNED_CERT_IN_CHAIN", "ERR_TLS_CERT_ALTNAME_INVALID",
    "ERR_INVALID_CHAR", "ERR_SQLITE_ERROR", "SQLITE_BUSY", "SQLITE_READONLY", "EACCES", "EPERM",
  ]);
  let current: unknown = error, code: string | undefined;
  for (let depth = 0; depth < 4 && current && typeof current === "object"; depth++) {
    if ("code" in current && typeof current.code === "string" && codes.has(current.code)) {
      code = current.code; break;
    }
    current = "cause" in current ? current.cause : undefined;
  }
  const name = error instanceof Error ? error.name : "";
  const category = ["TimeoutError", "AbortError"].includes(name) ? "request timed out or was aborted"
    : error instanceof SyntaxError ? "invalid JSON response"
    : error instanceof ZodError ? "unexpected response format"
    : code ? code : "unclassified failure";
  return new AppError(`Ring sync failed during ${stage} (${category}). No fixture fallback was used.`, stage === "local storage" ? 500 : 502);
}
