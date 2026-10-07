import type { Metadata } from "next";
import {
  PRIVACY_CLOSER_HEADING, PRIVACY_INTRO, PRIVACY_SECTIONS, PRIVACY_TITLE,
} from "@/lib/content";
import { LAST_REVIEWED } from "@/lib/site";

export const metadata: Metadata = {
  title: "dialogue privacy",
  description: "What stays on your device, what the site stores, and what dialogue never does.",
  alternates: { canonical: "/privacy", types: { "text/markdown": "/privacy.md" } },
};

export default function Privacy() {
  return (
    <main>
      <p className="kicker">privacy</p>
      <h1>{PRIVACY_TITLE}</h1>
      <p className="kicker">last reviewed {LAST_REVIEWED}</p>
      <p>{PRIVACY_INTRO}</p>

      {PRIVACY_SECTIONS.map((s) => (
        <section key={s.heading}>
          <h2>{s.heading}</h2>
          <p>{s.text}</p>
        </section>
      ))}

      <h2>{PRIVACY_CLOSER_HEADING}</h2>
      <p>
        Use the <a href="/support">support page</a> to contact us. Waitlist
        deletion requests are handled manually and confirmed when complete.
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/support">Support</a>
      </footer>
    </main>
  );
}
