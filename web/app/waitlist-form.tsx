"use client";

import { useState } from "react";
import { supabase } from "@/lib/supabase";

type FormState = "idle" | "working" | "done" | "duplicate" | "error";

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
    const { error } = await supabase
      .from("dialogue_waitlist")
      .insert({ email: trimmed, source: "web" });
    if (!error) {
      setState("done");
    } else if (error.code === "23505") {
      setState("duplicate");
    } else {
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

  if (state === "duplicate") {
    return <p className="form-note ok">Already in the ledger. Nothing more to do.</p>;
  }

  return (
    <form className="waitlist-form" onSubmit={submit}>
      <input
        type="email"
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
          That did not go through. Check the address and try again.
        </p>
      )}
    </form>
  );
}
