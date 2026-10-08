import type { Metadata } from "next";
import JsonLd from "../json-ld";
import {
  FAQ, SUPPORT_EMAIL, SUPPORT_INTRO_AFTER_EMAIL, SUPPORT_INTRO_BEFORE_EMAIL,
} from "@/lib/content";
import { LAST_REVIEWED, openGraphFor } from "@/lib/site";

export const metadata: Metadata = {
  title: "dialogue support",
  description: "Plain answers about the gate, the debrief, and what dialogue can and cannot see.",
  alternates: { canonical: "/support", types: { "text/markdown": "/support.md" } },
  openGraph: openGraphFor("/support"),
};

export default function Support() {
  return (
    <main>
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@type": "FAQPage",
          dateModified: LAST_REVIEWED,
          mainEntity: FAQ.map((f) => ({
            "@type": "Question",
            name: f.q,
            acceptedAnswer: { "@type": "Answer", text: f.a },
          })),
        }}
      />
      <p className="kicker">dialogue support</p>
      <h1>A little help.</h1>
      <p className="kicker">last reviewed {LAST_REVIEWED}</p>
      <p>
        {SUPPORT_INTRO_BEFORE_EMAIL}
        <a href={`mailto:${SUPPORT_EMAIL}`}>{SUPPORT_EMAIL}</a>
        {SUPPORT_INTRO_AFTER_EMAIL}
      </p>

      {FAQ.map((f) => (
        <section key={f.q}>
          <h2>{f.q}</h2>
          <p>{f.a}</p>
        </section>
      ))}

      <footer>
        <a href="/">Home</a>
        <a href="/privacy">Privacy</a>
      </footer>
    </main>
  );
}
