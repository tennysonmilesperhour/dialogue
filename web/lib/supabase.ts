import { createClient } from "@supabase/supabase-js";

// Server-side waitlist writer. The publishable key has INSERT access only.
export function waitlistClient() {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) throw new Error("Waitlist storage is not configured");
  return createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: {
      fetch: (input, options) => fetch(input, {
        ...options, signal: AbortSignal.timeout(10000),
      }),
    },
  });
}
