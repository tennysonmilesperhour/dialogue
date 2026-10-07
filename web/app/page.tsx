import type { Metadata } from "next";
import WaitlistForm from "./waitlist-form";
import JsonLd from "./json-ld";
import {
  GATE_AND_DEBRIEF, IMS_HEADING, IMS_TEXT, LEDGER_CAPTION, LEDGER_NOTE,
  LEDGER_ROWS, PITCH, REFUSALS, REFUSALS_CLOSER, REFUSALS_HEADING, SUMMARY,
  WAITLIST_HEADING, WAITLIST_TEXT,
} from "@/lib/content";
import { SITE_URL } from "@/lib/site";

export const metadata: Metadata = {
  alternates: { canonical: "/", types: { "text/markdown": "/index.md" } },
};

export default function Home() {
  return (
    <main>
      <JsonLd
        data={{
          "@context": "https://schema.org",
          "@graph": [
            {
              "@type": "WebSite",
              "@id": `${SITE_URL}/#site`,
              name: "dialogue",
              url: SITE_URL,
              description: SUMMARY,
              inLanguage: "en",
            },
            {
              "@type": "MobileApplication",
              "@id": `${SITE_URL}/#app`,
              name: "dialogue",
              description: SUMMARY,
              operatingSystem: "iOS 17 or later",
              applicationCategory: "HealthApplication",
              url: SITE_URL,
              subjectOf: { "@id": `${SITE_URL}/#site` },
            },
          ],
        }}
      />
      <p className="kicker">an iOS app, in the works</p>
      <h1>dialogue</h1>
      <p style={{ fontSize: 21 }}>
        Every screen time app tells you how long.{" "}
        <strong>dialogue tells you whether you meant it.</strong>
      </p>

      <p>{PITCH}</p>

      <div className="card" aria-label="A sample gate card">
        <div className="app-line">
          <span>instagram</span>
          <span>9:47 pm</span>
        </div>
        <p style={{ marginBottom: 8 }}>Why are you opening it?</p>
        <p className="reminder" style={{ marginBottom: 0 }}>
          You wanted evenings for the book.
        </p>
        <div className="chip-row">
          <span className="chip">Reply</span>
          <span className="chip">Look up</span>
          <span className="chip">Post</span>
          <span className="chip honest">Bored</span>
          <span className="chip honest">Avoiding something</span>
        </div>
        <div className="gate-buttons">
          <span className="btn primary">Never mind</span>
          <span className="btn secondary">Enter</span>
        </div>
      </div>

      <p>{GATE_AND_DEBRIEF}</p>

      <h2>{IMS_HEADING}</h2>
      <p>{IMS_TEXT}</p>

      <table className="ledger">
        <caption>{LEDGER_CAPTION}</caption>
        <thead>
          <tr>
            <th>Stated reason</th>
            <th style={{ textAlign: "right" }}>Avg session</th>
            <th style={{ textAlign: "right" }}>Matched</th>
          </tr>
        </thead>
        <tbody>
          {LEDGER_ROWS.map((r) => (
            <tr key={r.reason}>
              <td>{r.reason}</td>
              <td className="num">{r.avg}</td>
              <td className="num">{r.matched}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <p>{LEDGER_NOTE}</p>

      <h2>{REFUSALS_HEADING}</h2>
      <p>
        {REFUSALS.map((r, i) => (
          <span key={r.lead}>
            <strong>{r.lead}</strong> {r.text}
            {i < REFUSALS.length - 1 ? <br /> : null}
          </span>
        ))}{" "}
        <em>{REFUSALS_CLOSER}</em>
      </p>

      <h2>{WAITLIST_HEADING}</h2>
      <p>{WAITLIST_TEXT}</p>
      <WaitlistForm />

      <p style={{ marginTop: 60 }}>
        <span className="stamp">Logged</span>{" "}
        <span className="stamp red" style={{ transform: "rotate(3deg)" }}>
          Dismissed +1
        </span>
      </p>

      <footer>
        <a href="/privacy">Privacy</a>
        <a href="/support">Support</a>
        <span>dialogue, in progress, {new Date().getFullYear()}</span>
      </footer>
    </main>
  );
}
