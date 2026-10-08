# CLAUDE.md

Read `docs/CONTEXT.md` first in any session on this repo. It is the map.

Hard rules that apply to every file, commit, and UI string in this project:

- Never use em dashes. Use commas, parentheses, or rewrite.
- No exclamation points, no emoji, no guilt copy in product strings. Voice rules in `docs/IDENTITY.md`.
- The debrief is two taps, permanently. Any feature that adds a required tap to it is rejected by default.
- dialogue never blocks. Enter is always reachable.
- No usage data leaves the device except the user's own logged entries.

Repo layout (target state, see `docs/ARCHITECTURE.md`):

```
Dialogue/              main app
DialogueShield/        shield configuration extension
DialogueShieldAction/  shield action extension
DialogueMonitor/       device activity monitor extension
DialogueReport/        device activity report extension
DialogueKit/           shared Swift package: models, IMS math, design tokens
Prototype/             week-1 throwaway close-detection lab (never ships)
web/                   Next.js marketing site + waitlist
docs/                  strategy docs and submission paperwork
```

The agent-access layer (llms.txt, markdown twins, bot log, monthly review) is planned and logged in `docs/planning/agent-access-2026-10.md`. Page copy for the site lives in `web/lib/content.ts`.

The execution plan and its gates live in `docs/PLAN.md`. Log every decision in `docs/DECISIONS.md`, append-only.

CI runs five jobs on every pull request: copy lint (the voice rules above,
mechanically), the web build with a high-severity dependency audit, the five
iOS targets generated from `project.yml` and built with the device SDK, and
`swift test` for DialogueKit, and iPhone interface tests. Run the lint locally with
`python3 scripts/copy_lint.py`. To quote copy that breaks a rule on purpose,
mark the line `copy-lint: allow` or wrap the block in `copy-lint: off` and
`copy-lint: on`.

Two jobs run outside pull requests. A manual `workflow_dispatch` run does the
full release verification (`scripts/verify_release.sh`), and every merge to
main uploads a TestFlight build once the signing secrets exist, skipping
cleanly until then. See `fastlane/README.md`.

The Xcode project is generated, never committed (D015). Run
`xcodegen generate` after pulling, before opening Xcode.
