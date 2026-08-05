# DECISIONS.md

Append-only. Newest at the bottom. Format: decision, date, rationale, what would reverse it.

---

**D001. The product is the exit debrief, not the entry gate.**
2026-08-03. Every competitor owns the entry pause and abandons the exit. The debrief is the only defensible position and the source of the one metric.
*Reverses if:* beta debrief completion falls below 35% after two rounds of friction reduction.

**D002. Never block. Enter is always available.**
2026-08-03. Self-determination theory predicts reactance from controlling restriction. Blockers also enter a bypass arms race and collect the resulting one-star reviews. Autonomy support is the strategy, not a compromise.
*Reverses if:* never. This is identity, not tactics.

**D003. Intention Match Score is the single metric.**
2026-08-03. Minutes cannot distinguish good time from stolen time. IMS can. Formula in ARCHITECTURE.md, Partly at half credit, unlogged sessions excluded entirely.
*Reverses if:* users cannot understand it in onboarding without explanation.

**D004. Friction adapts downward with good behavior.**
2026-08-03. Habituation is the documented killer of every friction app, with users autopiloting through static pauses within weeks. Inverting friction into a consequence gives the gate a reason to keep varying.
*Deferred to V1.1.* Ship static standard tier first to gather calibration data.

**D005. iOS only for V1.**
2026-08-03. Screen Time API is native. Android's UsageStatsManager is technically easier but the audience and willingness to pay are stronger on iOS. One platform done well.
*Reverses if:* iOS close-detection proves unworkable, at which point Android becomes the better first platform.

**D006. Honest reasons are first-class.**
2026-08-03. "Bored" and "Avoiding something" appear in the default chip set. If honest answers are punished at the gate, users learn to lie, and lied-to data makes IMS worthless.
*Reverses if:* never.

**D007. Analog ledger aesthetic, heavy ink version.**
2026-08-03. Chose the original hard-bordered ruled-paper design over the sleeker iOS-native pass. The category is uniformly soft gradients; the ink weight is the differentiator and reads as serious rather than soothing.
*Reverses if:* Shield template constraints make it impossible to render convincingly on the gate, which is where it matters most.

**D008. Name is "dialogue", lowercase.**
2026-08-03. The name maps to the architecture: opening line, closing line, ongoing conversation. Lowercase signals the app's non-authoritative posture.
*Blocked on:* USPTO and App Store clearance. Dialogue Health Technologies holds the name in telehealth. Do not commission brand assets until cleared.

**D009. One-time purchase plus optional light subscription, not subscription-only.**
2026-08-03. Subscription resentment is the dominant complaint pattern in the category, and the one app people do not resent paying for is the one with a one-time price. Full reasoning in MONETIZATION.md.
*Reverses if:* one-time revenue cannot cover ongoing API maintenance after 12 months of data.

**D010. Debrief is two taps, permanently.**
2026-08-03. Verdict tap plus Log tap. The note field is optional and never blocks. Any feature that adds a required tap to the debrief is rejected by default.
*Reverses if:* never.

**D011. Submit all five Family Controls entitlement requests on day one.**
2026-08-03. Requests are per bundle ID, including every extension, and approval runs from about four business days to several weeks. The development entitlement works locally in the meantime, so this cost is zero if submitted early and fatal if submitted late.

---

*Next decisions pending: D012 close-detection and gate-flow verdict (week 1 prototype: direct link, notification hop, or notification-action chips), D013 login method (proposal: Sign in with Apple only, decide before the Sync build), free tier boundary (before beta), launch pricing test (before public launch), EU DSA trader vs US-first launch (weeks 7 to 8).*
