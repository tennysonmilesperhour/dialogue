import type { Metadata } from "next";
import JsonLd from "../json-ld";
import { FAQ, SUPPORT_CONTACT } from "@/lib/content";
import { CONTACT_URL, LAST_REVIEWED } from "@/lib/site";

export const metadata: Metadata = {
  title: "dialogue support",
  description: "Plain answers about the gate, the debrief, and what dialogue can and cannot see.",
  alternates: { canonical: "/support", types: { "text/markdown": "/support.md" } },
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
      <p className="kicker">support</p>
      <h1>Questions, answered plainly</h1>
      <p className="kicker">last reviewed {LAST_REVIEWED}</p>

      {FAQ.map((f) => (
        <section key={f.q}>
          <h2>{f.q}</h2>
          <p>{f.a}</p>
        </section>
      ))}

      <h2>Contact</h2>
      <p>
        <a href={CONTACT_URL}>Open a support request on GitHub</a>
        {SUPPORT_CONTACT.replace("Open a support request on GitHub", "")}
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/privacy">Privacy</a>
      </footer>
    </main>
  );
}
