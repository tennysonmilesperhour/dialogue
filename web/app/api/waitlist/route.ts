import { createWaitlistHandler } from "@/lib/waitlist";

export const maxDuration = 25;

export const POST = createWaitlistHandler({
  supabaseUrl: process.env.SUPABASE_URL,
  serviceKey: process.env.SUPABASE_SERVICE_ROLE_KEY,
  turnstileSecret: process.env.TURNSTILE_SECRET_KEY,
});
