import { NextResponse } from "next/server";
import { waitlistClient } from "@/lib/supabase";

export async function POST(request: Request) {
  let body;
  try { body = await request.json(); }
  catch { return NextResponse.json({ error: "Invalid request" }, { status: 400 }); }
  const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";
  if (email.length > 320 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return NextResponse.json({ error: "Enter a valid email address" }, { status: 400 });
  }
  try {
    const { error } = await waitlistClient().from("dialogue_waitlist").insert({ email, source: "web" });
    // Same response for new and existing entries, so the list stays private.
    if (error && error.code !== "23505") throw error;
    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ error: "The waitlist is temporarily unavailable" }, { status: 503 });
  }
}
