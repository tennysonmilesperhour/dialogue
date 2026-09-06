export type WaitlistConfig = {
  supabaseUrl?: string;
  serviceKey?: string;
  turnstileSecret?: string;
};

const response = (status: number, message: string) =>
  Response.json(
    { message },
    { status, headers: { "Cache-Control": "no-store" } },
  );
const success = () =>
  response(
    200,
    "Your request is logged. We will write when the beta is ready.",
  );

async function readBody(request: Request): Promise<unknown> {
  const reader = request.body?.getReader();
  if (!reader) throw new Error("Missing body");
  const chunks: Uint8Array[] = [];
  let length = 0;
  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      length += value.byteLength;
      if (length > 4096) throw new Error("Body too large");
      chunks.push(value);
    }
  } finally {
    await reader.cancel();
    reader.releaseLock();
  }
  const bytes = new Uint8Array(length);
  let offset = 0;
  for (const chunk of chunks) {
    bytes.set(chunk, offset);
    offset += chunk.length;
  }
  return JSON.parse(new TextDecoder().decode(bytes));
}

/** Public requests never receive database errors or membership information. */
export function createWaitlistHandler(
  config: WaitlistConfig,
  fetcher: typeof fetch = fetch,
) {
  return async function POST(request: Request): Promise<Response> {
    const origin = new URL(request.url).origin;
    if (request.headers.get("origin") !== origin)
      return response(403, "Please submit from the dialogue website.");
    if (!request.headers.get("content-type")?.startsWith("application/json"))
      return response(415, "Expected a form submission.");
    let body: unknown;
    try {
      body = await readBody(request);
    } catch {
      return response(400, "Check your email address and try again.");
    }
    if (!body || typeof body !== "object")
      return response(400, "Check your email address and try again.");
    const { email, token, website } = body as Record<string, unknown>;
    if (typeof website === "string" && website.length > 0) return success();
    if (
      typeof email !== "string" ||
      email.trim().length > 254 ||
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())
    ) {
      return response(400, "Enter a valid email address.");
    }
    if (!config.supabaseUrl || !config.serviceKey || !config.turnstileSecret) {
      return response(
        503,
        "Signups are temporarily paused. Please check back later.",
      );
    }
    if (typeof token !== "string" || !token || token.length > 2048)
      return response(400, "Complete the verification and try again.");
    try {
      const verification = await fetcher(
        "https://challenges.cloudflare.com/turnstile/v0/siteverify",
        {
          method: "POST",
          body: new URLSearchParams({
            secret: config.turnstileSecret,
            response: token,
          }),
          signal: AbortSignal.timeout(8000),
        },
      );
      if (!verification.ok)
        return response(
          503,
          "Verification is unavailable. Please try again later.",
        );
      const result = await verification.json();
      if (
        result.success !== true ||
        result.hostname !== new URL(origin).hostname ||
        result.action !== "waitlist"
      ) {
        return response(400, "Verification expired. Please try again.");
      }
      const saved = await fetcher(
        new URL("/rest/v1/dialogue_waitlist", config.supabaseUrl),
        {
          method: "POST",
          headers: {
            apikey: config.serviceKey,
            Authorization: `Bearer ${config.serviceKey}`,
            "Content-Type": "application/json",
            Prefer: "return=minimal",
          },
          body: JSON.stringify({
            email: email.trim().toLowerCase(),
            source: "web",
          }),
          signal: AbortSignal.timeout(8000),
        },
      );
      if (saved.ok) return success();
      const error = await saved.json().catch(() => null);
      if (saved.status === 409 && error?.code === "23505") return success();
      return response(
        503,
        "Your request could not be saved. Please try again later.",
      );
    } catch {
      return response(
        503,
        "The connection did not complete. Please try again.",
      );
    }
  };
}
