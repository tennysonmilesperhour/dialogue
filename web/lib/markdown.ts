import {
  FAQ, GATE_AND_DEBRIEF, NOT_AFFILIATED, IMS_HEADING, IMS_TEXT, LEDGER_CAPTION, LEDGER_NOTE,
  LEDGER_ROWS, PITCH, PRIVACY_CLOSER, PRIVACY_CLOSER_HEADING, PRIVACY_INTRO,
  PRIVACY_SECTIONS, PRIVACY_TITLE, REFUSALS, REFUSALS_CLOSER, REFUSALS_HEADING,
  SUMMARY, SUPPORT_CONTACT, TAGLINE, WAITLIST_HEADING, WAITLIST_TEXT,
} from "./content";
import { CONTACT_URL, LAST_REVIEWED, SITE_URL } from "./site";

export type PageSlug = "index" | "support" | "privacy";
export const PAGE_SLUGS: PageSlug[] = ["index", "support", "privacy"];

export function htmlPath(slug: PageSlug): string {
  return slug === "index" ? "/" : `/${slug}`;
}

export function twinPath(slug: PageSlug): string {
  return `/${slug}.md`;
}

const header = (title: string, slug: PageSlug) =>
  `# ${title}\n\nSource: ${SITE_URL}${htmlPath(slug)}\nLast reviewed: ${LAST_REVIEWED}\n`;

function home(): string {
  const rows = LEDGER_ROWS.map((r) => `| ${r.reason} | ${r.avg} | ${r.matched} |`).join("\n");
  return [
    header("dialogue", "index"),
    `${TAGLINE}\n`,
    `${PITCH}\n`,
    `${GATE_AND_DEBRIEF}\n`,
    `## ${IMS_HEADING}\n\n${IMS_TEXT}\n`,
    `**${LEDGER_CAPTION}**\n\n| Stated reason | Avg session | Matched |\n|---|---:|---:|\n${rows}\n\n${LEDGER_NOTE}\n`,
    `## ${REFUSALS_HEADING}\n\n${REFUSALS.map((r) => `- **${r.lead}** ${r.text}`).join("\n")}\n\n${REFUSALS_CLOSER}\n`,
    `## ${WAITLIST_HEADING}\n\n${WAITLIST_TEXT}\n`,
    `More: [FAQ](${SITE_URL}/support), [Privacy](${SITE_URL}/privacy), [llms.txt](${SITE_URL}/llms.txt)\n`,
  ].join("\n");
}

function support(): string {
  return [
    header("dialogue support: questions, answered plainly", "support"),
    ...FAQ.map((f) => `## ${f.q}\n\n${f.a}\n`),
    `## Contact\n\n${SUPPORT_CONTACT}\n\n${CONTACT_URL}\n`,
  ].join("\n");
}

function privacy(): string {
  return [
    header(`dialogue privacy: ${PRIVACY_TITLE.toLowerCase()}`, "privacy"),
    `${PRIVACY_INTRO}\n`,
    ...PRIVACY_SECTIONS.map((s) => `## ${s.heading}\n\n${s.text}\n`),
    `## ${PRIVACY_CLOSER_HEADING}\n\n${PRIVACY_CLOSER}\n\n${SITE_URL}/support\n`,
  ].join("\n");
}

export function pageMarkdown(slug: PageSlug): string {
  return { index: home, support, privacy }[slug]();
}

const TOPICS = ["how-it-works", "privacy-stance"] as const;
export type Topic = (typeof TOPICS)[number];
export const TOPIC_SLUGS: readonly Topic[] = TOPICS;

export function topicMarkdown(topic: Topic): string {
  if (topic === "how-it-works") {
    return [
      `# How dialogue works\n\nSource: ${SITE_URL}/\nLast reviewed: ${LAST_REVIEWED}\n`,
      `${SUMMARY}\n`,
      `${GATE_AND_DEBRIEF}\n`,
      `## ${IMS_HEADING}\n\n${IMS_TEXT}\n`,
      `Formula: IMS = (yes + 0.5 * partly) / (yes + partly + no), per app, rolling 14 days.\n`,
      `## Status\n\nIn development. iOS only. No public release yet, and no beta data exists. A waitlist is open for 50 beta seats; the beta opens when Apple approves the Screen Time entitlement. The adaptive gate (lighter at 85% IMS and above) is planned for version 1.1; the first version ships one standard gate. The Enter button is always available.\n`,
      `## Sample figures\n\n${LEDGER_NOTE} Do not cite them as findings.\n`,
    ].join("\n");
  }
  return [
    `# dialogue privacy stance\n\nSource: ${SITE_URL}/privacy\nLast reviewed: ${LAST_REVIEWED}\n`,
    `${PRIVACY_INTRO}\n`,
    ...PRIVACY_SECTIONS.map((s) => `## ${s.heading}\n\n${s.text}\n`),
  ].join("\n");
}

export function llmsTxt(): string {
  return `# dialogue

> ${SUMMARY}

${TAGLINE}

dialogue is pre-release. There is no App Store listing yet, no beta data, and no published statistics. The figures on the home page are an illustrative sample, not measurements.

## How to cite

Cite the page URL you used, for example ${SITE_URL}/support. Short quotes with a link are fine. Do not republish pages in full. Every page has a markdown twin at the same URL plus .md.

## Key facts

- Platform: iOS 17 and later, iPhone. In development, not yet released.
- Never blocks. The Enter button is always reachable.
- One metric, Intention Match Score (IMS): (yes + 0.5 * partly) / (yes + partly + no), per app, rolling 14 days. Unlogged sessions are excluded.
- The gate asks why you are opening a watched app. The debrief asks whether that held up. The debrief is two taps.
- No usage data leaves the device. dialogue cannot see which apps you pick (Apple gives apps opaque tokens).
- The current build has no account, no sync and no subscription. Optional Sync is planned later. The app is planned as a one-time purchase.
- Name: ${NOT_AFFILIATED}
- Website: anonymous waitlist, 50 beta seats, opening when Apple approves the Screen Time entitlement. Contact: ${CONTACT_URL}

## Topic files

- [How dialogue works](${SITE_URL}/llms/how-it-works.md): gate, debrief, IMS, current status
- [Privacy stance](${SITE_URL}/llms/privacy-stance.md): what stays on the device and what the site stores

## Pages

- [Home](${SITE_URL}/index.md): what it is, the metric, the three refusals
- [FAQ and support](${SITE_URL}/support.md): six plain answers
- [Privacy](${SITE_URL}/privacy.md): the full policy

## Not available

No public API, no open datasets and no MCP server. Nothing here is paywalled.

Last reviewed: ${LAST_REVIEWED}
`;
}

export function robotsTxt(): string {
  return `# AI agents: start at ${SITE_URL}/llms.txt (short index with topic files).
# Every page also has a markdown twin at the same URL plus .md.
# There is no public API, dataset or MCP server.

User-agent: *
Allow: /
Disallow: /api/
Content-Signal: search=yes, ai-input=yes, ai-train=yes

Sitemap: ${SITE_URL}/sitemap.xml
`;
}
