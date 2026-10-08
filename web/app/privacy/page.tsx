import type { Metadata } from "next";
import {
  PRIVACY_CLOSER_AFTER_EMAIL, PRIVACY_CLOSER_BEFORE_EMAIL, PRIVACY_CLOSER_HEADING,
  PRIVACY_INTRO, PRIVACY_SECTIONS, PRIVACY_TITLE, PRIVACY_UPDATED, SUPPORT_EMAIL,
} from "@/lib/content";

export const metadata: Metadata = {
  title: "dialogue privacy",
  description: "What stays on your device, what the site stores, and what dialogue never does.",
  alternates: { canonical: "/privacy", types: { "text/markdown": "/privacy.md" } },
};

export default function Privacy() {
  return (
    <main>
      <p className="kicker">privacy · updated {PRIVACY_UPDATED}</p>
      <h1>{PRIVACY_TITLE}</h1>
      <p>{PRIVACY_INTRO}</p>

      {PRIVACY_SECTIONS.map((s) => (
        <section key={s.heading}>
          <h2>{s.heading}</h2>
          <p>{s.text}</p>
        </section>
      ))}

      <h2>{PRIVACY_CLOSER_HEADING}</h2>
      <p>
        {PRIVACY_CLOSER_BEFORE_EMAIL}
        <a href={`mailto:${SUPPORT_EMAIL}`}>{SUPPORT_EMAIL}</a>
        {PRIVACY_CLOSER_AFTER_EMAIL}
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/support">Support</a>
      </footer>
    </main>
  );
}
