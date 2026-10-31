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
- The site says version 1.0 is free (copy from main). MONETIZATION.md still describes a paid model, which now disagrees with the site.
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

### Accuracy pass (2026-10-07, redone 2026-10-08 after main rewrote the copy)

First pass found the home page claiming sync, "one price, once", a not-yet-live adaptive gate, and a loose IMS definition, plus an unlabelled sample table. PR 17 (main) then rewrote the site copy: version 1.0 is free and local-only, the adaptive gate is in the app (`GateTier.next` in `Dialogue/Sources/DialogueModel.swift`), and the privacy page now discloses PostHog and the support email. The content module was rebuilt on that copy and rechecked against the code. What remains from this layer:

- IMS text states Partly at half credit, the 14 day window and per-app scope, matching ARCHITECTURE.md and the support FAQ.
- The sample ledger is captioned "illustrative sample, not measured data" on the page, in the markdown twin and in llms.txt.
- Beta line says it opens when Apple approves the Screen Time entitlement. Owner approved.
- FAQ and llms.txt say dialogue is not affiliated with Dialogue Health Technologies. Owner approved.
- Privacy page gained an "Automated visitors" section for the bot log. docs/submission/PRIVACY_POLICY.md has the matching line.

### Open findings for the owner

- PostHog: the privacy page now discloses it, so the earlier contradiction is gone. The owner still chose to leave the key unset. The key is set on Vercel (production and development). Deleting it is an owner action in Vercel.
- Resolved 2026-10-31: `docs/ARCHITECTURE.md` and `docs/ROADMAP.md` said the adaptive gate ships in V1.1, but the app already applies tiers. Both docs now match the code, logged as D023.
- New 2026-10-31: web search confuses the name with "Dialogue: AI Character Chat" (an unrelated App Store app). The site's not-affiliated line names only Dialogue Health Technologies. Whether to name the chat app too is the owner's call (naming another company is outward-facing).

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

- 2026-10-08: merged main (PR 17) into the branch, which also carried the lock-timing fix for the DialogueKit test. Content module rebuilt on main's copy, decision renumbered D021.
- 2026-10-07: layer built. Accuracy pass fixed five items (above), two open findings raised. Traffic log not yet live, awaiting migration and secrets.
- 2026-10-08: reran failed CI once. The lock timing test failed again, confirming that attempt-count timing stretched under runner load. Replaced it with a monotonic one second deadline.
- 2026-10-31: November review, run early from a session because the first-Wednesday Action (4 Nov) will be its first scheduled run; earlier exports came from a manual run on 8 Oct, and the Wednesday runs since then exited at the date gate as designed. Export `docs/agent-review/2026-10-31.json`. Live checks: all 11 pass (8 agent files plus the three markdown alternate links), against 8 Oct when every agent file returned 404 before the deploy. Traffic: not measured. The log is still not connected (migration not confirmed applied, repo secrets `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` not confirmed; this session cannot read repo secrets), so there are no visit counts, no agent-file use and no unknown user agents to add to `web/lib/agents.ts`. Search test, 6 of the common questions in web search plus a site: query (no separate assistant run): dialogue appeared in none of them and `site:dialogue-five.vercel.app` returned nothing, so the site does not look indexed yet. Answers cited one sec, Opal, ScreenZen, Are You Sure, BrainPet, Intent Note and the Android app Why?. "Does dialogue collect or sell my usage data" returned the unrelated Dialogue: AI Character Chat, whose App Store label lists tracking data (finding above). Accuracy audit, month 1, home page: every fact in `web/lib/content.ts` home copy checked against the code (IMS formula, 14 day window and exclusion of unlogged visits in `IMS.swift`, default chips, two-tap reflection, adaptive pause, free and local-only 1.0) and holds. Two design-mock details are not facts and were left: the mock gate asks "Why are you opening it?" where the app asks "What brings you here?", and the "Logged" stamp has no animation in the app. `LAST_REVIEWED` not bumped, because only the home page was re-checked and the date also stands on support and privacy. Freshness: entitlement still unanswered, 1.0 still free and local-only, nothing to change. Improvement: the how-it-works topic file now states the full adaptive pause rule (12 reflections, 0, 3 or 8 seconds, once per 72 hours, never a lock) so an agent asked whether dialogue blocks has the whole answer. Backlog "how it compares" page: not built. RESEARCH.md cites the one sec field study and the psychology base by author and year, but nothing about Opal, ScreenZen, Clearspace, Freedom or Jomo, and the category table in CONTEXT.md carries no citations, so the page could not cite every claim. RESEARCH.md section 2 also still says a chip must be selected before Enter unlocks, which D019 reversed; it needs a note before any page quotes it.
