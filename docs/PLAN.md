# PLAN.md

*The execution plan for taking dialogue from these docs to an approved App Store release. This file sequences ROADMAP.md into gated phases and records what a full doc review surfaced: four technical assumptions to correct, one timeline conflict, and the App Store compliance work the current plan does not cover.*

Section 2 is the review, what should change in the existing docs and why. Section 3 is the phase plan with exit gates. Section 4 is the submission checklist. Nothing here changes the product thesis; CONTEXT.md and INTENT.md stand as written.

## 1. Where things stand

- The repo is documentation only. No Xcode project, no web app, no CI.
- The strategy docs are in good shape. The two flagged unknowns (close detection, entitlement latency) are the right two, and the refuse-to-build list will save weeks.
- The gaps concentrate in three places: iOS API mechanics the architecture is optimistic about, App Store compliance work that appears nowhere in the roadmap, and a scheduling conflict between the beta and the submission date.

## 2. Doc review findings

### 2.1 Technical corrections for ARCHITECTURE.md

Four assumptions need validation or correction before production code. All four fold into the week 1 prototype, which is already the plan; this list makes the prototype's questions explicit.

**A. The shield action extension likely cannot open dialogue directly.**
ARCHITECTURE.md has the secondary button deep-linking into the chip card. As of iOS 17, `ShieldActionDelegate` can only respond with `.close`, `.defer`, or `.none`, and extensions have no `openURL`. The commonly used workaround is for the action extension to post a local notification whose tap deep-links into the app, which adds one tap to the "Choose a reason" path. Week 1 must measure whether that hop is acceptable.

Fallback worth prototyping alongside it: **reason chips as notification action buttons.** A notification category supports up to four actions, so the default chip set ("Reply", "Look up", "Bored", "Other") can ride on the notification itself. Tapping an action logs the reason and clears the shield with no app switch at all. If the direct deep link is impossible, this may actually be the better gate, and it keeps D010's two-tap budget.

**B. The 90 second grace window has no obvious timer.**
Extensions cannot run timers, the main app only runs timers while foregrounded, and `DeviceActivitySchedule` intervals have a 15 minute minimum. Candidate re-arm mechanisms to test: a one minute usage-threshold `DeviceActivityEvent` on the unshielded app whose callback re-shields (grace becomes "about a minute of use, plus callback latency"), or re-shielding when dialogue next foregrounds. Monitor callbacks are also widely reported to fire minutes late. Consequence: treat the grace window and all session lengths as approximate by design, which the honesty rule in ARCHITECTURE.md already accommodates. Spec the default as "short" and let the prototype pick the real number.

**C. App display names are not available to the app.**
`Application.localizedDisplayName` and `bundleIdentifier` are nil outside the report extension, by privacy design. The app can render a picked app's name and icon only through the SwiftUI `Label(token)` view, which is display-only. So `apps.display_name` in the data model cannot be populated programmatically. Fix: during onboarding, after the picker, ask the user to name each watched app ("What do you call this app?"). This fits the ledger posture, you label your own columns, and it is load-bearing: without it, the debrief notification ("How did that Instagram session go?"), the weekly review, and the web view have no app names to print.

**D. The report extension is display-only.**
`DeviceActivityReportExtension` renders Apple-computed usage inside a sandboxed view and cannot pass numbers back to the app or write to shared storage. Nothing in the session-length pipeline may depend on it. It shows figures; it never sources them.

Also fold in: shield extensions run under a roughly 6MB memory ceiling, so they must not spin up the shared SwiftData container. Pattern: extensions append minimal records to a lightweight app group store (small files or defaults), and the main app ingests them into SwiftData on next launch. One writer per store, always.

### 2.2 The beta and the submission overlap

ROADMAP.md submits at week 11 and launches at week 12, but the six week beta that produces the go/no-go number starts at week 6 and does not finish until week 12. As written, the launch decision consumes data that does not exist yet.

Fix, without extending the calendar: submit at week 11 with **manual release** selected, and move the decision to an interim checkpoint.

- **Beta week 3 checkpoint (calendar week 9):** debrief completion at or above 50% and holding: proceed to submission prep.
- **35 to 50%:** one round of friction reduction, extend the beta two weeks, submission slips to week 13.
- **Below 35%:** stop. D001's reversal condition has fired; rework before further spend.

App Review takes days to weeks for Screen Time apps anyway, so submitting on interim data and holding the release button until the beta confirms costs nothing and removes the conflict.

### 2.3 Compliance items missing from the roadmap

None of these are optional; each has blocked real submissions.

| Item | When | Note |
|---|---|---|
| App Store name reservation | Week 0 | App names are unique per storefront and the bare word "dialogue" is likely taken. Create the App Store Connect record in week 0 and pick the fallback (for example "dialogue: intention ledger") calmly, not under submission pressure. Subtitle stays "Did you mean to open that?" |
| Privacy policy + support URLs live | Week 5, not weeks 7 to 10 | Required for external TestFlight, not just the App Store. One page on Vercel is enough. |
| Beta App Review | Week 5 | External TestFlight builds go through their own review. Budget a few days, more for Screen Time apps. |
| Privacy manifest | Weeks 2 to 4 | `PrivacyInfo.xcprivacy` for required-reason APIs. RevenueCat, Supabase, and TelemetryDeck ship their own; keep them current. |
| App Privacy nutrition label | Week 11 | Must match the manifest and actual sync behavior. Minimal by design here. |
| In-app account deletion | Weeks 7 to 10 | Required because Sync creates accounts (Guideline 5.1.1). Wire full Supabase deletion before submission, not after a rejection. |
| Sign in with Apple | Weeks 7 to 10 | Required if any third-party login ships. Recommendation: Sign in with Apple as the only login. Lowest friction through both Supabase and review. |
| Export compliance | Week 11 | `ITSAppUsesNonExemptEncryption = NO` in every target's Info.plist; standard HTTPS is exempt. |
| EU DSA trader status | Weeks 7 to 8 | Required to sell paid IAP in the EU. Verification can take weeks and publishes your contact details on the product page. Start early, or launch US-first deliberately. |
| Small Business Program | Week 0 | Apply immediately after enrollment. The 15% rate in MONETIZATION.md assumes approval. |
| IAP products in the first review | Week 11 | The one-time unlock and both Sync subscriptions must be attached to the build. The paywall must show price, term, and links to privacy policy and EULA. |
| TestFlight needs the Distribution entitlement | Week 6 dependency | The development Family Controls entitlement covers Xcode installs only. Every TestFlight build, internal or external, is distribution-signed. **The week 6 beta is therefore gated on the week 0 entitlement approvals.** If approvals slip past week 5, the beta slips with them; the only workaround is hand-installing dev builds on a handful of devices. |

The last row is the quiet one. ROADMAP.md treats entitlement approval as a week 11 concern. It is a week 6 concern.

### 2.4 Process gaps

- **CI.** Xcode Cloud (simplest for this stack) or GitHub Actions with fastlane. Every merge to main produces a TestFlight build. Set it up in week 0 while the project is empty and cheap to configure.
- **Tests.** DialogueKit is where correctness lives: unit tests for IMS math (Partly at half credit, unlogged excluded, 14 day window edges), tier transitions (12 session minimum, 72 hour clamp), and close-source labeling. UI tests for the chip card and the two-tap debrief.
- **Copy lint.** IDENTITY.md's rules are mechanical: fail CI on em dashes, exclamation points, and emoji in any string catalog. Cheap to build, enforces the voice forever.
- **Crash reporting.** MetricKit plus the Xcode Organizer, no third-party crash SDK. Keeps the privacy story clean for the entitlement review.
- **Supabase RLS.** Row-level security on every ledger table from the first migration. Sync is per-user private data; there is no shared read path, ever.

## 3. Phase plan

Phases mirror ROADMAP.md weeks. Each has an exit gate; do not start the next phase with a gate open.

### Phase 0: setup (days 1 to 2)

- [x] Apple Developer Program active (team T4PQ8SNY8D). Small Business Program application still outstanding
- [x] Register all five bundle IDs (list in ARCHITECTURE.md), plus the `group.app.dialogue` App Group. Done 2026-08-19
- [x] Submit the Family Controls (Distribution) request. Done 2026-08-19. Corrected: it is **one team-level request**, not five, and the form has no use-case field to fill (D016). The wording drafted here was never submitted because there was nowhere to put it.
- [ ] Create the App Store Connect app record; resolve the name or lock the fallback (2.3)
- [ ] USPTO and App Store search on "dialogue" (D008 is blocked on this)
- [ ] Secure domain and social handles
- [ ] Xcode workspace scaffolded: app, four extensions, DialogueKit package, shared app group; builds and runs on a physical device
- [ ] CI bootstrapped with a TestFlight upload lane
- [x] `web/` scaffolded (Next.js on Vercel); privacy and support pages live

**Exit gate:** all five entitlement requests submitted, and the empty workspace installs on a device.

### Phase 1: de-risk (week 1)

The throwaway prototype answers, on a physical device, with answers logged in DECISIONS.md:

- [ ] Shield an app, render the gate within the template, capture both button actions
- [ ] Measure the shield-to-app hop: possible directly, or notification only, and at what cost in seconds and taps (2.1.A)
- [ ] Prototype reason chips as notification actions, the fallback gate (2.1.A)
- [ ] Determine real re-arm granularity and monitor callback latency across a full day (2.1.B)
- [ ] Grade layer 1 (re-arm timestamps) session lengths against reality
- [ ] Gate card at production fidelity within the real template constraints (D007 reverses here if the ledger aesthetic cannot land)

**Exit gate:** D012 logged in DECISIONS.md covering the close-detection verdict, the gate flow shape (direct link, notification hop, or notification-action chips), and grace mechanics. No production code before this entry exists.

### Phase 2: core build (weeks 2 to 4)

Everything in ROADMAP.md weeks 2 to 4, plus:

- [ ] Per-app naming step in onboarding (2.1.C)
- [ ] Extensions write to the lightweight app group store; main app ingests into SwiftData (2.1)
- [ ] Privacy manifest in place across targets
- [ ] DialogueKit unit tests green; copy lint running in CI

**Exit gate:** the full gate, session, debrief loop works offline on a device through three straight days of self-use, and the builder's own IMS renders correctly.

### Phase 3: review layer and beta prep (week 5)

Everything in ROADMAP.md week 5, plus:

- [ ] Privacy and support pages live
- [ ] External TestFlight build submitted to Beta App Review
- [ ] Recruiting posts drafted for the channels listed in ROADMAP.md

**Exit gate:** a stranger can install the beta from a TestFlight link. Hard dependency: Distribution entitlements approved (2.3).

### Phase 4: beta (weeks 6 to 11)

- [ ] 50 external users, six week window, day 30 instrumented hard
- [ ] Week 3 checkpoint drives the submission decision (2.2)

### Phase 5: monetization, sync, web (weeks 7 to 10, parallel with beta)

Everything in ROADMAP.md weeks 7 to 10, plus:

- [ ] In-app account deletion, complete server-side wipe
- [ ] Sign in with Apple as the only login
- [ ] Supabase RLS verified per table
- [ ] EU DSA trader verification started (or US-first decision logged)
- [ ] Paywall shows price, term, privacy policy, EULA
- [ ] Shareable reason-cost card (the launch asset, built in-app)

**Exit gate:** purchase, restore, and account deletion all pass in sandbox; the paywall passes a self-review against the subscription guidelines.

### Phase 6: submission (week 11)

Checklist in section 4. Submit with manual release selected.

### Phase 7: launch (week 12, gated on the beta checkpoint)

- [ ] Launch assets per ROADMAP.md, priority order unchanged, reason-cost table first
- [ ] Release the approved build manually when the beta checkpoint confirms

## 4. Submission checklist (week 11)

*Field-by-field values for every App Store Connect box below, plus the
privacy label answers, the IAP definitions, and the screenshot spec, live in
`docs/submission/APP_STORE_METADATA.md`.*

**Binary**
- [ ] All five entitlements show Distribution in the portal
- [ ] Every provisioning profile regenerated after that, then a clean archive (a main app on Distribution with one extension still on Development is the classic silent killer, per ROADMAP.md)
- [ ] Shield extension memory profiled under the ceiling on the oldest supported device
- [ ] Privacy manifests present, app and SDKs
- [ ] Export compliance key set in every target

**App Store Connect**
- [ ] Name resolved, subtitle "Did you mean to open that?", category Health & Fitness, secondary Productivity
- [ ] IAPs attached to the build: one-time unlock, Sync monthly, Sync annual
- [ ] App Privacy label matches reality: nothing linked to identity on free tier; account data listed only for Sync
- [ ] Age rating questionnaire completed
- [ ] Screenshots in the current required sizes, order per IDENTITY.md: gate, debrief with stamp, weekly review, home, adaptive gate explainer
- [ ] Privacy policy and support URLs set
- [ ] Manual release selected

**Review notes**
- [ ] Personal digital wellbeing tool for the account holder's own device, not parental control
- [ ] The app never blocks; Enter is always available (state it plainly, reviewers assume blockers)
- [ ] No advertising, no profiling; nothing leaves the device except user-authored entries under an optional account
- [ ] Step-by-step demo script: grant Screen Time authorization, pick one app, trigger the gate, enter, close, complete the debrief
- [ ] Note that Screen Time authorization is required for core function

**Contingency**
- [ ] Budget two to three review cycles; keep launch content decoupled from the approval date

## 5. Risk register additions

Beyond INTENT.md's five:

6. **Shield-to-app hop friction.** If choosing a reason costs a notification tap, gate completion may sag. Mitigation: notification-action chips keep it to two taps with no app switch; prototype both shapes in week 1.
7. **Entitlement approval gates the beta, not just launch.** No full workaround exists. Check request status weekly; escalate through developer support at day 10 of silence.
8. **Name collision.** If "dialogue" is unavailable as an App Store name, the brand survives through the wordmark and a qualified store name. Decide the fallback in week 0.
9. **Callback latency noise.** If close timestamps run minutes late, session lengths blur but verdicts survive. IMS is verdict-based, so the one metric is robust to this. Label lengths as approximate everywhere, which is already policy.

## 6. Edits to the existing docs (applied 2026-08-05)

- **ARCHITECTURE.md:** absorbed 2.1, the gate flow (notification hop or notification-action chips), grace mechanics as approximate, user-entered app names, report extension as display-only, and the extension write pattern.
- **ROADMAP.md:** absorbed 2.2 (checkpointed go/no-go, manual release) and 2.3 (compliance items in their weeks, privacy pages moved to week 5, the TestFlight entitlement dependency called out in the critical path), plus the distribution loop from section 7.
- **DECISIONS.md:** pending list now reserves D012 for the week 1 prototype verdict and D013 for the login decision.
- **IDENTITY.md:** per-app naming ("What do you call this app?") added to the design language as a load-bearing element (2.1.C).

## 7. Borrowed from the fast-shipper playbook

Reviewed a circulating indie playbook (demand-first idea selection, rapid wireframes, AI-assisted build, ship V1 in hours, distribute through UGC creators and paid ads, relentless iteration, a portfolio of 45+ apps). The claims are survivorship-flavored, one $30K/month hit implies a long tail of quiet deaths, but the system underneath is sound. What transfers to dialogue and what does not:

**Adopt**

- **Demand signal before code.** The playbook starts with market, not code. dialogue's equivalent: the waitlist page goes live in week 0 while the entitlement requests sit in Apple's queue. Zero cost, and it converts the entitlement wait into a demand test. Added to ROADMAP.md week 0.
- **Distribution as a system, not a launch event.** The playbook's real edge is not build speed, it is a standing distribution loop. dialogue has two natively shareable artifacts (the gate card and the reason cost table); the loop is weekly short-form content built on them, plus a handful of UGC creators in the digital wellbeing niche. Added to ROADMAP.md as its own section.
- **Paid acquisition, gated.** Running ads to acquire users does not threaten the Family Controls entitlement (the entitlement risk is collecting usage data for advertising, which never happens here). But paid spend waits for organic conversion data. Small tests only after the funnel converts.
- **Fast kill criteria.** The hidden lesson of 45 apps: most died quickly and cheaply. dialogue already has this discipline. The week 1 prototype is the cheap death, and the 35% debrief floor (D001) is the kill switch. Keep both sacred.
- **Paywall iteration discipline.** Their Superwall maps to RevenueCat experiments here, already planned. The part worth copying is cadence: instrument the paywall funnel from day one and run the MONETIZATION.md pricing tests on a calendar, not "eventually."

**Reject**

- **Ship V1 in hours.** Impossible for this product (entitlement approval, five native targets) and wrong for it: the moat is a considered mechanism, not speed to market. The speed lesson still applies where it can: the week 1 throwaway prototype and a TestFlight build on every merge.
- **Subscription-paywall maximization.** The playbook's monetization tooling exists to optimize subscription conversion. dialogue's entire wedge is refusing the category's subscription treadmill (D009). Optimizing the one-time paywall is fine; importing hard-sell mechanics is brand suicide.
- **Portfolio thinking, for now.** One app, one platform, done well (INTENT.md). The portfolio lesson applies in exactly one form: if the kill criteria fire, actually kill it and move on.
