# CONTEXT.md

*Read this first in any Claude Code session on this repo.*

## What dialogue is

An iOS app that wraps each session in a watched app with a two-sided ritual. On the way in, a gate asks why you are opening it. On the way out, a debrief asks whether that turned out to be true. The record that accumulates between those two questions is the product.

dialogue never blocks. The Enter button is always available. What changes over time is how much friction stands in front of it.

## The one metric

**Intention Match Score (IMS).** Percent of sessions where the user's exit verdict was Yes, weighted with Partly at half credit, over a rolling 14 days, per app.

Screen time is a shame number. IMS is an integrity number. Every screen, every notification, every marketing claim points back to IMS. If a feature does not make IMS more accurate or more actionable, it does not ship.

## Category position

| Category | Examples | Their model | dialogue |
|---|---|---|---|
| Friction | one sec, ScreenZen, Clearspace | Pause before opening | Pause before AND reflect after |
| Blockers | Opal, Freedom, Jomo | Lock you out | Never blocks |
| Environment | Blank Spaces | Hide the icons | Icons stay |
| Trackers | Screen Time, RescueTime | Report minutes | Report intention accuracy |

Two things nobody else does:

1. **The exit debrief.** Every competitor intervenes before the open and abandons you after. The debrief is the entire moat.
2. **Friction that scales down.** High IMS earns a lighter gate. Friction as consequence, not constant. This directly answers the documented habituation problem that kills every friction app around week three.

## Known category failure modes (design constraints, not trivia)

- **Habituation.** Users learn to autopilot through a static pause within roughly 10 to 30 days. Answered by the adaptive gate and prompt rotation.
- **Subscription resentment.** The dominant 1-to-3-star complaint across Opal, Freedom, one sec, and Jomo is surprise auto-renewal and price-to-value mismatch. Forest is the only app in the category people do not resent paying for, and it is the only one with a one-time purchase. See MONETIZATION.md.
- **Bypass.** Hard blockers get defeated and then get blamed. dialogue sidesteps this by never claiming to block.

## Who it is for

Adults who are already self-aware about their phone use and have tried a blocker that they either defeated or resented. Not parents managing kids. Not people who want a wall. People who want a record.

## Stack

Swift/SwiftUI (iOS 17+), Screen Time API (FamilyControls, ManagedSettings, DeviceActivity), Supabase for the ledger and auth, Next.js + Vercel for marketing site and weekly review web view. See ARCHITECTURE.md.

## Non-negotiables

- Never blocks. Enter is always reachable.
- Debrief is two taps. If it grows past two taps, the product dies.
- No usage data leaves the device except the user's own logged entries. Never sell, never profile, never advertise. This is also an Apple entitlement requirement.
- Honest reasons ("Bored", "Avoiding something") are first-class options, never punished at the gate.
- Never use em dashes in any copy, doc, or UI string.

## Doc map

- INTENT.md, what success looks like and what we refuse to build
- IDENTITY.md, voice, design language, naming
- ARCHITECTURE.md, technical structure and data model
- DECISIONS.md, the running log of choices and why
- ROADMAP.md, build phases and App Store rollout
- MONETIZATION.md, pricing model and rationale
- RESEARCH.md, the psychology base with citations
