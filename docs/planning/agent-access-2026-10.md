# Agent access, 2026-10

## Goal

Let AI assistants, AI crawlers and automation find, read, trust and cite the dialogue marketing site, without exposing anything about any user. Scope is `web/` only. No MCP server, no datasets: there is no data worth publishing yet (no beta exists) and nothing about any user's sessions or ledger may ever be exposed.

## Research (October 2026, re-check before changing direction)

- Big AI crawlers rarely read llms.txt and Google ignores it. Agents a person sends to a page do read it. Keep it short and point to small topic files. Server HTML stays the main surface.
- AI answers cite original data, fresh pages with visible dates, and open pages. We have no original data yet, so freshness, accuracy and clarity are the levers.
- No major assistant pays per request. Nothing here is paywalled or charged.
- Worth adopting: Content Signals in robots.txt. Skipped here: Dataset markup, MCP, api-catalog and server card (nothing to list), agents.json, ai-plugin.json.

## Decisions

- D021 in `docs/DECISIONS.md`: the bot log, what it stores, why browsers are never logged.
- Review cadence is monthly (light), first Wednesday: Action 16:20 UTC, routine session 16:55 UTC.
- Pricing figures are not published on the site. MONETIZATION.md says the price is still under test.
- Sample ledger numbers on the home page stay, but are labelled as a design sample everywhere, including the markdown twin and llms.txt, so no assistant quotes them as findings.
- Domain is `https://dialogue-five.vercel.app` until a real one is bought (IDENTITY.md). All absolute URLs come from `web/lib/site.ts` (`NEXT_PUBLIC_SITE_URL` overrides).

## What shipped

Copy and structured data, one source: `web/lib/content.ts`.

| Piece | Path |
|---|---|
| Page copy, FAQ, privacy text, llms facts | `web/lib/content.ts` |
| Markdown, llms.txt and robots.txt builders | `web/lib/markdown.ts` |
| Site URL and last-reviewed date | `web/lib/site.ts` |
| Pages (render from content, JSON-LD, canonical, markdown alternate link) | `web/app/page.tsx`, `web/app/support/page.tsx`, `web/app/privacy/page.tsx`, `web/app/json-ld.tsx` |
| Markdown twins `/index.md`, `/support.md`, `/privacy.md` with canonical Link header | `web/app/md/[slug]/route.ts`, rewrites in `web/next.config.mjs` |
| `/llms.txt` (about 2 KB) | `web/app/llms.txt/route.ts` |
| Topic files `/llms/how-it-works.md`, `/llms/privacy-stance.md` | `web/app/llms/[topic]/route.ts` |
| `/robots.txt` with `Content-Signal: search=yes, ai-input=yes, ai-train=yes` | `web/app/robots.txt/route.ts` |
| `/sitemap.xml` | `web/app/sitemap.ts` |
| Bot detection list | `web/lib/agents.ts` |
| Bot logger (Next proxy, bots only, never blocks) | `web/proxy.ts` |
| Log table, write function, review function, prune function | `supabase/migrations/20261007120000_agent_traffic.sql` |
| Monthly export script and Action | `scripts/agent_review.py`, `.github/workflows/agent-review.yml` |
| Exports | `docs/agent-review/YYYY-MM-DD.json` |

JSON-LD: WebSite and MobileApplication on `/`, FAQPage on `/support`. The app has no offer or price in the markup on purpose.

### Accuracy fixes made (2026-10-07)

- Home said reasons stay on device "unless you choose to sync them". The current build has no sync or account. Now says so.
- Home said "One price, once" while MONETIZATION.md plans an optional Sync subscription. Now: one price for the app, optional Sync planned as a separate later add-on.
- Home and FAQ described the adaptive gate (85% IMS whisper) as live. ARCHITECTURE.md and D004 ship a static standard gate in V1 and turn adaptation on in V1.1. Now marked planned for 1.1.
- Home defined IMS without Partly at half credit, the 14 day window, or the per-app scope. Now matches ARCHITECTURE.md.
- The sample ledger table was captioned "sample" only. Now "illustrative sample, not measured data" plus a note.

### Open findings for the owner (not changed)

- `web/instrumentation-client.ts` sends anonymous pageviews to PostHog when `NEXT_PUBLIC_POSTHOG_KEY` is set, while the privacy page and `docs/submission/PRIVACY_POLICY.md` say "no analytics cookies, no trackers". Either leave the key unset or disclose anonymous pageview counts in both policies.
- Resolved 2026-10-07: beta line now says it opens when Apple approves the entitlement, and a not-affiliated line (FAQ and llms.txt) separates dialogue from Dialogue Health Technologies. Owner approved both.
- PostHog: the key is set on Vercel (production and development). Owner approved leaving it unset. Removing it is an owner action in Vercel; until then the privacy page should not claim "no trackers".

### Live setup still needed

- Apply the migration to the Supabase project behind `SUPABASE_URL` (project ref `xyhbuqsxglfjbounogdz`, not reachable from the build sessions).
- Add repo secrets `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` so the Action can read the summary and prune. Without them the export still runs the live checks and says the traffic part was skipped.
- Confirm `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` are set in the Vercel project (the waitlist already needs them).

## Monthly review steps (light)

1. Read the newest `docs/agent-review/*.json`: live check failures first, then traffic (by agent and kind, agent-file use, unknown user agents, previous period).
2. Add any recurring unknown user agent to `web/lib/agents.ts` with the right kind.
3. Ask 5 to 8 of the common questions below in web search and in an assistant. Note which sources are cited and whether dialogue appears or is confused with Dialogue Health Technologies or another product.
4. Accuracy audit on one rotating area: month 1 home page, 2 FAQ and privacy, 3 llms files against docs, 4 docs/submission against the site. Fix wrong facts in `web/lib/content.ts` and bump `LAST_REVIEWED` in `web/lib/site.ts` only when content was re-checked.
5. Freshness: if the beta, entitlement, price or sync status changed in `docs/ROADMAP.md` or `docs/DECISIONS.md`, update the site copy to match.
6. Build one improvement. Keep the rules: no em or en dashes, no exclamation points, no emoji, no guilt copy, nothing about any user's sessions.
7. Run `python3 scripts/copy_lint.py` and `npm run build` in `web/`, then add a Review log line below.

Anything outward-facing that is not already a recorded decision (new pages, claims, policy wording, buying a domain, naming another company) is a recommendation to Tennyson, not a change.

## Common questions to test

- What is dialogue, the iOS app that asks why you opened an app?
- Is there a screen time app that does not block apps?
- What is an Intention Match Score?
- Does dialogue see which apps I use?
- Does dialogue collect or sell my usage data?
- Is dialogue free, and is it a subscription?
- How do I join the dialogue beta?
- dialogue vs one sec vs Opal vs ScreenZen
- Why does an iOS app not know exactly when I close another app?

## Backlog

- A real domain (IDENTITY.md lists candidates), then update `NEXT_PUBLIC_SITE_URL`.
- A "how it compares" page, only with claims already in RESEARCH.md that have citations.
- A short "what the debrief asks" page with the two taps, if searches show that question unanswered.
- After the beta: aggregate, consented IMS results as open data, with a minimum sample size. Revisit MCP and Dataset markup only then.

## Outlook

- 1 year: app released, a few cited pages, real aggregate results from the beta if consent allows.
- 2 years: a dataset worth citing, only if it stays aggregate and consented.
- 5 years: the category answer for "did you mean it" questions, or no agent layer needed because the app speaks for itself.

## Review log

- 2026-10-07: layer built. Accuracy pass fixed five items (above), two open findings raised. Traffic log not yet live, awaiting migration and secrets.
- 2026-10-08: reran failed CI once. The lock timing test failed again, confirming that attempt-count timing stretched under runner load. Replaced it with a monotonic one second deadline.
