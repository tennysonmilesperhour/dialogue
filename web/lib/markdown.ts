import {
  FAQ, GATE_AND_DEBRIEF, IMS_HEADING, IMS_TEXT, LEDGER_CAPTION, LEDGER_NOTE,
  LEDGER_ROWS, NOT_AFFILIATED, PITCH, PRIVACY_CLOSER_AFTER_EMAIL,
  PRIVACY_CLOSER_BEFORE_EMAIL, PRIVACY_CLOSER_HEADING, PRIVACY_INTRO,
  PRIVACY_SECTIONS, PRIVACY_TITLE, PRIVACY_UPDATED, REFUSALS, REFUSALS_HEADING,
  SUMMARY, SUPPORT_EMAIL, SUPPORT_INTRO_AFTER_EMAIL, SUPPORT_INTRO_BEFORE_EMAIL,
  TAGLINE, WAITLIST_HEADING, WAITLIST_TEXT,
} from "./content";
import { LAST_REVIEWED, SITE_URL } from "./site";

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
    `## ${REFUSALS_HEADING}\n\n${REFUSALS.map((r) => `- **${r.lead}** ${r.text}`).join("\n")}\n`,
    `## ${WAITLIST_HEADING}\n\n${WAITLIST_TEXT}\n`,
    `More: [FAQ](${SITE_URL}/support), [Privacy](${SITE_URL}/privacy), [llms.txt](${SITE_URL}/llms.txt)\n`,
  ].join("\n");
}

function support(): string {
  return [
    header("dialogue support: a little help", "support"),
    `${SUPPORT_INTRO_BEFORE_EMAIL}${SUPPORT_EMAIL}${SUPPORT_INTRO_AFTER_EMAIL}\n`,
    ...FAQ.map((f) => `## ${f.q}\n\n${f.a}\n`),
  ].join("\n");
}

function privacy(): string {
  return [
    header("dialogue privacy", "privacy"),
    `Updated ${PRIVACY_UPDATED}\n`,
    `${PRIVACY_INTRO}\n`,
    ...PRIVACY_SECTIONS.map((s) => `## ${s.heading}\n\n${s.text}\n`),
    `## ${PRIVACY_CLOSER_HEADING}\n\n${PRIVACY_CLOSER_BEFORE_EMAIL}${SUPPORT_EMAIL}${PRIVACY_CLOSER_AFTER_EMAIL}\n`,
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
      `## Status\n\nIn development. iPhone only. No public release yet, and no beta data exists. A waitlist is open; the beta opens when Apple approves the Screen Time entitlement. Gate friction adapts to your own match rate after enough reflections: lighter at 85% IMS and above. The Continue path is always available, and all gates can be paused in Settings.\n`,
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

- Platform: iPhone, iOS 17 and later. In development, not yet released.
- Never blocks. The Enter button is always reachable.
- One metric, Intention Match Score (IMS): (yes + 0.5 * partly) / (yes + partly + no), per app, rolling 14 days. Unlogged sessions are excluded.
- The gate asks why you are opening a watched app. The debrief asks whether that held up. The debrief is two taps.
- No usage data leaves the device. dialogue cannot see which apps you pick (Apple gives apps opaque tokens).
- Version 1.0 is free, local-only, with no account, no cloud sync, no subscription and no in-app purchases.
- Name: ${NOT_AFFILIATED}
- Website: beta waitlist, opening when Apple approves the Screen Time entitlement. Contact: ${SUPPORT_EMAIL}

## Topic files

- [How dialogue works](${SITE_URL}/llms/how-it-works.md): gate, debrief, IMS, current status
- [Privacy stance](${SITE_URL}/llms/privacy-stance.md): what stays on the device and what the site stores

## Pages

- [Home](${SITE_URL}/index.md): what it is, the metric, the three refusals
- [FAQ and support](${SITE_URL}/support.md): nine plain answers
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
Host: ${SITE_URL}
`;
}
