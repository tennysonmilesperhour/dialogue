import { NextResponse, type NextFetchEvent, type NextRequest } from "next/server";
import { classify } from "@/lib/agents";

// Logs visits from known bots and tools only. Never runs for browsers, never
// stores an IP address, never blocks or slows a response (D020).
export function proxy(request: NextRequest, event: NextFetchEvent) {
  const ua = request.headers.get("user-agent") || "";
  const hit = ua ? classify(ua) : null;
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_PUBLISHABLE_KEY;
  if (hit && url && key) {
    event.waitUntil(
      fetch(`${url}/rest/v1/rpc/dialogue_log_agent_hit`, {
        method: "POST",
        headers: {
          apikey: key,
          authorization: `Bearer ${key}`,
          "content-type": "application/json",
        },
        body: JSON.stringify({
          p_agent: hit.agent,
          p_kind: hit.kind,
          p_path: request.nextUrl.pathname,
          p_ua: ua,
        }),
        signal: AbortSignal.timeout(3000),
      }).catch(() => {}),
    );
  }
  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!api/|_next/|favicon.ico|md/).*)"],
};
