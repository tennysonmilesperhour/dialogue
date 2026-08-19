# dialogue

An iOS app that wraps each session in a watched app with a two-sided ritual: a gate that asks why you are opening it, and a debrief that asks whether that turned out to be true. It never blocks. The record between those two questions is the product.

Status: phase 0. Strategy docs complete, the five app targets and DialogueKit scaffolded, week-1 prototype ready to run, waitlist site live.

## Layout

- `docs/`, all strategy docs. Start with `docs/CONTEXT.md`.
- `docs/submission/`, entitlement request text, privacy policy, review notes
- `project.yml`, the XcodeGen spec every app target is generated from (D015)
- `Dialogue/`, main app
- `DialogueShield/`, shield configuration extension (the gate card)
- `DialogueShieldAction/`, shield action extension (the two buttons)
- `DialogueMonitor/`, device activity monitor extension (session events)
- `DialogueReport/`, device activity report extension (usage figures, display only)
- `DialogueKit/`, shared Swift package: IMS math, tier rules, design tokens, tests
- `Prototype/CloseDetectionLab/`, the week-1 throwaway prototype (never ships)
- `web/`, Next.js marketing site and waitlist

## Build the app

The `.xcodeproj` is generated and gitignored, so the target graph stays
reviewable. Regenerate it after every pull.

1. `brew install xcodegen`
2. `xcodegen generate` in the repo root, which writes `Dialogue.xcodeproj`
3. Open it and set your team on all five targets
4. Confirm each target shows Family Controls and the `group.app.dialogue`
   App Group in Signing and Capabilities
5. Run on a physical device. Screen Time APIs do nothing in the simulator.

What phase 0 ships is a smoke test, not the product: Home reports whether
Screen Time access is granted, whether the app group is readable from the
app, and whether DialogueKit linked. The extensions register their callbacks
and render the gate template with the ledger tokens. The gate, the debrief,
and the ledger arrive in phase 2, after the week-1 prototype settles D012.

Run the DialogueKit tests with `swift test` in `DialogueKit/`, and the copy
lint with `python3 scripts/copy_lint.py` from the root.

## Doc map (in docs/)

- CONTEXT.md, read first in any session
- INTENT.md, success criteria and what we refuse to build
- IDENTITY.md, voice, design language, naming
- ARCHITECTURE.md, stack, data model, interception flow
- DECISIONS.md, running log of choices and why
- ROADMAP.md, build phases and App Store rollout
- MONETIZATION.md, pricing model and rationale
- RESEARCH.md, the psychology base with citations
- PLAN.md, gated execution plan and doc-review findings
