# dialogue

An iOS app that wraps each session in a watched app with a two-sided ritual: a gate that asks why you are opening it, and a debrief that asks whether that turned out to be true. It never blocks. The record between those two questions is the product.

Status: phase 0. Strategy docs complete, DialogueKit and the week-1 prototype scaffolded, waitlist site live.

## Layout

- `docs/`, all strategy docs. Start with `docs/CONTEXT.md`.
- `docs/submission/`, entitlement request text, privacy policy, review notes
- `DialogueKit/`, shared Swift package: IMS math, tier rules, design tokens, tests
- `Prototype/CloseDetectionLab/`, the week-1 throwaway prototype (never ships)
- `web/`, Next.js marketing site and waitlist

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
