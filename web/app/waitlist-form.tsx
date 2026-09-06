"use client";

import Script from "next/script";
import { useEffect, useRef, useState } from "react";

declare global {
  interface Window {
    turnstile?: {
      render: (
        element: HTMLElement,
        options: Record<string, unknown>,
      ) => string;
      reset: (id: string) => void;
      remove: (id: string) => void;
    };
  }
}

export default function WaitlistForm({ siteKey }: { siteKey: string | null }) {
  const [email, setEmail] = useState("");
  const [token, setToken] = useState("");
  const [state, setState] = useState<"idle" | "working" | "done" | "error">(
    "idle",
  );
  const [message, setMessage] = useState("");
  const [scriptReady, setScriptReady] = useState(false);
  const container = useRef<HTMLDivElement>(null);
  const widget = useRef<string | null>(null);
  const submitting = useRef(false);
  const status = useRef<HTMLParagraphElement>(null);

  const isDone = state === "done";

  useEffect(() => {
    if (
      !scriptReady ||
      !siteKey ||
      !container.current ||
      !window.turnstile ||
      isDone
    )
      return;
    widget.current = window.turnstile.render(container.current, {
      sitekey: siteKey,
      action: "waitlist",
      theme: "light",
      size: "compact",
      callback: (value: string) => setToken(value),
      "expired-callback": () => setToken(""),
      "error-callback": () => {
        setToken("");
        setMessage(
          "Verification could not load. Check your connection and reload this page.",
        );
      },
    });
    return () => {
      if (widget.current) window.turnstile?.remove(widget.current);
      widget.current = null;
    };
  }, [scriptReady, siteKey, isDone]);

  useEffect(() => {
    if (state === "done") status.current?.focus();
  }, [state]);

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (submitting.current) return;
    submitting.current = true;
    const website = new FormData(event.currentTarget).get("website");
    setState("working");
    setMessage("");
    try {
      const result = await fetch("/api/waitlist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, token, website }),
        signal: AbortSignal.timeout(20000),
      });
      const body = await result.json();
      setMessage(
        body.message || "Your request could not be saved. Please try again.",
      );
      setState(result.ok ? "done" : "error");
      if (result.ok) setEmail("");
    } catch {
      setState("error");
      setMessage(
        "The connection did not complete. Your address is still here. Please try again.",
      );
    } finally {
      submitting.current = false;
      setToken("");
      if (widget.current) window.turnstile?.reset(widget.current);
    }
  }

  if (!siteKey)
    return (
      <p className="availability-note">
        Signups are paused while we prepare the beta. You can try the preview
        above and check back here for availability.
      </p>
    );

  return (
    <>
      <Script
        src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit"
        onReady={() => setScriptReady(true)}
        onError={() =>
          setMessage("Verification could not load. Please reload this page.")
        }
      />
      {state !== "done" && (
        <form
          className="waitlist-form"
          onSubmit={submit}
          aria-busy={state === "working"}
        >
          <label htmlFor="waitlist-email">Email address</label>
          <div className="form-controls">
            <input
              id="waitlist-email"
              name="email"
              type="email"
              required
              maxLength={254}
              autoComplete="email"
              placeholder="you@example.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              aria-describedby="waitlist-privacy waitlist-status"
              disabled={state === "working"}
            />
            <button
              className="btn primary"
              type="submit"
              disabled={state === "working" || !token}
            >
              {state === "working"
                ? "Saving your request…"
                : "Request beta access"}
            </button>
          </div>
          <div className="honeypot" aria-hidden="true">
            <label>
              Website
              <input name="website" tabIndex={-1} autoComplete="off" />
            </label>
          </div>
          <div ref={container} className="verification" />
          <p id="waitlist-privacy" className="form-note">
            Beta and launch updates only.{" "}
            <a href="/privacy">How we handle your address</a>.
          </p>
        </form>
      )}
      <p
        ref={status}
        id="waitlist-status"
        tabIndex={-1}
        role="status"
        aria-live="polite"
        className={`form-note ${state === "done" ? "ok" : "err"}`}
      >
        {message}
      </p>
    </>
  );
}
