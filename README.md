# dialogue

An iOS app that wraps each session in a watched app with a two-sided ritual: a gate that asks why you are opening it, and a debrief that asks whether that turned out to be true. It never blocks. The record between those two questions is the product.

Status: the local-first product loop is implemented across all five app targets. Onboarding, watched app setup, the intention gate, session monitoring, debrief, ledger, IMS, weekly review, and settings are ready for physical-device validation.

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

The main app and extensions share one compact, on-device ledger through the
App Group. The shield records walk-aways and routes intentional visits into
the reason gate. Device Activity closes visits at the selected soft budget,
re-arms the shield, and requests the debrief.

Run the DialogueKit tests with `swift test` in `DialogueKit/`, and the copy
lint with `python3 scripts/copy_lint.py` from the root.

For a complete unsigned App Store configuration check, run
`scripts/verify_release.sh`. It tests DialogueKit, audits and builds the web
app, builds every iOS target with the device SDK, and inspects the resulting
app and extension bundles. Signing, entitlement approval, and the physical
device prototype remain external checks. See
`docs/submission/LAUNCH_READINESS.md` for the current launch gate.

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
- submission/LAUNCH_READINESS.md, verified release checks and open launch gates
