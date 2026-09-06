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

**D014. Store name: claim "dialogue" if it is free, but ship "dialogue: intention ledger" unless a trademark search clears.**
2026-08-18. App Store Connect enforces exact-string uniqueness and nothing about trademarks, so availability and safety are two different questions. A US store search found Dialogue AAC, Dialogue Health, and Dialogue: Your Chats Live On live, none of them holding the bare string, so the name may well be free; the authoritative check is typing it into the app record. The trademark question is the one that matters. Dialogue Health Technologies runs a health and wellness platform with a live US listing, and dialogue files under Health & Fitness, so it is the same word on the same shelf. The qualified store name costs nothing, because the wordmark carries the brand and the keyword field carries search, and it removes the collision. Full reasoning in docs/submission/APP_STORE_METADATA.md section 2.
*Reverses if:* an attorney's class 9 and class 44 search comes back clean, at which point ship the bare word.

**D015. The Xcode project is generated from `project.yml`, never committed.**
2026-08-19. Five targets, five bundle IDs, five entitlement files, and one app group have to stay in lockstep, and a mismatch between them is the classic silent submission killer (ROADMAP.md's warning about one extension left on Development signing). A `.pbxproj` is a binary-shaped file nobody reviews and every merge conflicts in. XcodeGen makes the target graph a reviewable 160 line spec, and CI regenerates and builds it on every pull request, so a broken target fails in review rather than at archive time. Cost: one `brew install xcodegen` in setup, and the project has to be regenerated after pulling.
*Reverses if:* XcodeGen cannot express something Xcode needs (Xcode Cloud workflow config or a capability it does not model), at which point commit the project file and accept the review cost.


**D016. Family Controls is one team-level entitlement, not five per-bundle requests.**
2026-08-19. Submitted the request and found the process is not what D011 and
ENTITLEMENT_REQUEST.md described. Apple's form at
developer.apple.com/contact/request/family-controls-distribution now has no
bundle ID field and no use-case text box. It prefills name, email, and Team ID,
states the terms, and offers a single Get Entitlement button. The grant is per
developer team, so one submission covers every bundle ID under T4PQ8SNY8D.
The use-case statement drafted in ENTITLEMENT_REQUEST.md had nowhere to go.

Submitted 2026-08-19 for team T4PQ8SNY8D. Apple replied "we will review your
request and contact you soon with a status update", so it is reviewed rather
than instant. Status still unknown; check weekly and escalate through developer
support after 10 days of silence, exactly as ROADMAP.md says.

What this changes: the "five requests, five approvals" framing in D011,
ROADMAP.md, and PLAN.md section 2.3 is obsolete. Risk 7 (entitlement approval
gates the beta) survives unchanged, because one team-level approval still gates
every TestFlight build. The registration work is real and done: all five bundle
IDs exist with Family Controls (Development) and App Groups enabled, plus the
group.app.dialogue App Group.
*Reverses if:* Apple returns to a per-bundle-ID request flow.

**D017. Registered identifiers, 2026-08-19.**
app.dialogue.ios, app.dialogue.ios.shield, app.dialogue.ios.shieldaction,
app.dialogue.ios.monitor, app.dialogue.ios.report, all with Family Controls
(Development) and App Groups enabled, plus App Group group.app.dialogue. These
match project.yml and all five .entitlements files exactly. Note for anyone
re-creating the App Group: the portal field carries a fixed "group." prefix, so
type only "app.dialogue" into it.

---

*Next decisions pending: D012 close-detection and gate-flow verdict (week 1 prototype: direct link, notification hop, or notification-action chips), D013 login method (proposal: Sign in with Apple only, decide before the Sync build), free tier boundary (before beta), launch pricing test (before public launch), EU DSA trader vs US-first launch (weeks 7 to 8).*

**D018. Serialize local ledger writes and keep private content out of notifications.**
2026-09-06. The main app, shield action, and monitor are independent writers.
A protected App Group JSON file with a separate advisory lock now owns the
ledger and pending gate. Every mutation reads the latest record inside the
lock. Existing UserDefaults data migrates only after successful decoding and
writing. Unreadable data is never silently replaced. Notifications contain no
app name or intention, and deletion clears their pending and delivered copies.

**D019. Verify waitlist submissions on the server before opening beta signups.**
2026-09-06. Anonymous direct inserts allow verification bypass and membership
probing through uniqueness errors. The new endpoint requires server-verified
Turnstile tokens, normalizes email, bounds payload and network work, and returns
the same response for new and existing addresses. A migration revokes direct
browser access. Credentials are server-only, and the site displays paused
availability until all settings exist. Deploy the endpoint and migration as one
coordinated release after restoring a database. The current app is advertised
as free and local-only, with no account, subscription, or cloud sync.
