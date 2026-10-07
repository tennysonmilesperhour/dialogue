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


## 2026-09-07: Use the active shared Vibe Check backend

Move waitlist capture to the owner-selected active project. Keep the table app-specific and INSERT-only. Route writes through the server with environment-based configuration and a bounded timeout. Preserve the paused source for historical recovery. No changes to iOS ledger storage or account requirements.

**D018. TestFlight uploads run from fastlane in CI, signed against the five
named App Store profiles, and stay inert until the secrets exist.**
2026-09-27. PLAN.md section 2.4 asks for a TestFlight build on every merge to
main, and LAUNCH_READINESS.md still lists "produce a signed archive with
distribution provisioning for the app and all four extensions" as a P0
blocker. Three choices inside that:

Fastlane over Xcode Cloud, because the project is generated from project.yml
(D015) and Xcode Cloud wants a committed project to attach a workflow to.
Fastlane also runs the same lanes locally, so a hand-made archive and a CI
archive follow one path.

Download the existing profiles rather than adopting match. The Release configs
already sign manually against five profiles by name, set up while fixing
extension packaging, and match would rename all five and store a second
certificate in a new private repo. The lanes therefore run read-only: they
download profiles and import a certificate the team already has, and fail if
either is missing. A team gets very few distribution certificates, so CI must
never create one.

Build numbers diverge on purpose. A local archive uses
CURRENT_PROJECT_VERSION from project.yml, which verify_release.sh asserts
against, while CI passes the workflow run number, because TestFlight rejects a
build number it has already accepted and run numbers only climb.

The upload job checks for its five secrets and skips with an explanation when
any is missing, so the pipeline is honest about being unconfigured instead of
red. Setup steps in fastlane/README.md.
*Reverses if:* signing moves to Xcode Cloud, or a second machine needs the
certificate, at which point match earns its keep.

**D019. One writer at a time: the ledger moves from shared defaults to a
locked file in the App Group.**
2026-09-29. Ported from the audit on PR #11, which found it first. The main
app, the shield, the shield action, and the monitor are four independent
writers against one ledger, and the shipped design had each of them load the
whole state, change a field, and write the whole state back to a single
defaults key. Two callbacks overlapping meant one of them lost, silently: a
recorded dismissal or a closed visit simply gone, with nothing in the product
to reveal it. IMS is built on those records, so a lost write is a wrong number
in the one metric.

The ledger and the pending gate now live in a JSON file in the App Group
container, and every mutation reads the current record inside an advisory lock
on a separate lock file, so a reader never sees a half-written ledger and a
writer never overwrites a change it did not see. Data in the old defaults keys
migrates on first read and only after it decodes and the file write succeeds.
Unreadable data raises a storage error rather than being replaced with an
empty ledger, because a corrupt file the user can complain about beats a
blank one that looks like normal use.

An extension can be suspended mid-transaction, so the lock wait is bounded at
about a second and then reports a storage error through the recovery path the
app already has. Waiting forever inside a shield callback would be worse than
failing: dialogue never blocks, so a jammed store must fail open.

Two things ride along. Debrief notifications no longer name the app or the
intention, because a lock screen is a public surface and those strings are the
user's private content. And the App Group defaults declaration in the privacy
manifests stays `CA92.1`, not the `1C8F.1` that the audit branch used:
`1C8F.1` covers defaults only the app itself can reach, while `CA92.1` is the
one written for defaults shared across an App Group, which is what the
migration path still touches.
*Reverses if:* the lock proves too slow in a shield callback on a real device,
at which point the extensions write append-only records and the app folds them
in, which trades promptness for the same safety.

**D019. A release-quality local ledger, with optional friction.**
2026-10-06. Version 1.0 stays free and local-only. The welcome screen includes
an in-memory sample so users can understand the product before granting
Screen Time access. Gates accept custom or unspecified intentions and never
make a timer or typed word a prerequisite to continuing. Reflection is a
verdict plus Log, with notes, undo, and later editing. History has search and
a pending filter; Review uses calendar-based seven-day summaries and excludes
future entries. CSV/JSON exports omit app tokens and internal monitor IDs.
Sunday review reminders are opt-in. System dark mode, scalable type, minimum
touch targets, and reduced-motion-aware feedback are part of the release.
*Reverses if:* measured accessibility or device testing exposes a better
interaction; privacy and the always-available continuation remain fixed.

**D020. Correct the required-reason API mapping against Apple's source.**
2026-10-06. Apple's documentation defines CA92.1 for defaults only accessible
to the app itself and 1C8F.1 for defaults shared within an App Group. The
September 29 commit's explanation had these reversed. Every linked target
now declares 1C8F.1 for the legacy shared-defaults migration. The bounded lock
uses a monotonic elapsed-time deadline, with 35F9.1 declared for timer use.
Source: https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitypereasons
*Reverses if:* the APIs in the binary or Apple's required reasons change.
