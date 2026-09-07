"use client";

import { useState } from "react";

type FormState = "idle" | "working" | "done" | "error";

export default function WaitlistForm() {
  const [email, setEmail] = useState("");
  const [state, setState] = useState<FormState>("idle");

  async function submit(event: React.FormEvent) {
    event.preventDefault();
    const trimmed = email.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(trimmed)) {
      setState("error");
      return;
    }
    setState("working");
    try {
      const response = await fetch("/api/waitlist", {
        method: "POST", headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: trimmed }), signal: AbortSignal.timeout(15000),
      });
      setState(response.ok ? "done" : "error");
    } catch {
      setState("error");
    }
  }

  if (state === "done") {
    return (
      <p className="form-note ok">
        Logged. You are on the list. We will write when there is something
        worth opening.
      </p>
    );
  }

  return (
    <form className="waitlist-form" onSubmit={submit}>
      <input
        type="email"
        maxLength={320}
        required
        placeholder="you@example.com"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        aria-label="Email address"
        disabled={state === "working"}
      />
      <button className="btn primary" type="submit" disabled={state === "working"}>
        {state === "working" ? "Logging" : "Join the waitlist"}
      </button>
      {state === "error" && (
        <p className="form-note err">
          The waitlist is temporarily unavailable. Try again later.
        </p>
      )}
    </form>
  );
}
