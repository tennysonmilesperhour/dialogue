# ROADMAP.md

## Critical path

Two things gate everything and both must start on day one:

1. **Family Controls entitlement. Submitted 2026-08-19, awaiting reply.** Corrected against the live form: the grant is **per developer team, not per bundle ID**, and one submission covers all five identifiers. There is no use-case field to fill. See D016 and `docs/submission/ENTITLEMENT_REQUEST.md`. Approval is manually reviewed and runs from about four business days to several weeks. Development entitlement works locally in the meantime. Note: every TestFlight build, internal or external, is distribution-signed, so **entitlement approval gates the week 6 beta, not just the week 11 submission**. Check status weekly; escalate through developer support after 10 days of silence, so by 2026-08-31.
2. **Close-detection prototype.** If iOS cannot tell us when a session ended, the debrief degrades and the product changes shape. Answer this in week one, before writing production code.

---

## Week 0, setup (2 days)

- [x] Apple Developer Program enrollment active (team T4PQ8SNY8D). Small Business Program still to apply for (15% rate)
- [x] Register all five bundle IDs (see ARCHITECTURE.md), each with Family Controls (Development) and App Groups. Done 2026-08-19, plus the `group.app.dialogue` App Group
- [x] Submit the Family Controls (Distribution) request. Done 2026-08-19, one team-level request, no use-case field (D016)
- [ ] USPTO + App Store name clearance on "dialogue"
- [ ] Create the App Store Connect app record and resolve the store name now (the bare word is likely taken; pick the fallback calmly, not under submission pressure)
- [ ] Secure domain and social handles
- [ ] Repo initialized with these docs in `/docs`
- [ ] CI bootstrapped with a TestFlight upload lane (Xcode Cloud or GitHub Actions + fastlane)
- [ ] Marketing site stub live with a waitlist. Demand signal starts now, while the entitlement requests sit in Apple's queue, not at launch.

## Week 1, de-risk

- [ ] Throwaway prototype: shield an app, render a custom shield, capture Enter and Never mind actions
- [ ] Measure the shield-to-app hop. Direct open from the action extension is likely impossible (see ARCHITECTURE.md); test the notification deep link, and prototype reason chips as notification action buttons as the alternative gate shape
- [ ] Test all three close-detection layers on a physical device across a full day, including real re-arm granularity and callback latency
- [ ] **Gate decision:** does layer 1 (re-arm timestamp) give usable session lengths? Log the answer in DECISIONS.md before proceeding.
- [ ] Design the gate card at production fidelity within the shield template's real constraints

## Weeks 2 to 4, core build

- [ ] Onboarding: authorization, FamilyActivityPicker, per-app naming (tokens expose no display name), reminder line, chip setup, soft budgets
- [ ] Gate: shield config + shield action + the reason path the week 1 verdict picked
- [ ] Debrief: verdict, stat line, note, stamp animation
- [ ] Home: app rows with IMS, never-mind streak
- [ ] `DialogueKit`: IMS math, SwiftData models, design tokens
- [ ] Extensions write to a lightweight app group store; main app ingests into SwiftData
- [ ] Privacy manifest (`PrivacyInfo.xcprivacy`) across all targets
- [ ] DialogueKit unit tests (IMS math, tier rules) and copy lint (em dashes, exclamation points, emoji) in CI
- [ ] Local-only. No Supabase yet.

## Week 5, review layer

- [ ] Weekly review screen: IMS trend, reason cost table, one rule-based pattern
- [ ] Sunday evening local notification
- [ ] TelemetryDeck instrumentation on the four beta metrics (debrief completion, dismissal rate, retention, IMS trend)
- [ ] Privacy policy and support pages live (required for external TestFlight, not just the App Store)
- [ ] External build submitted to Beta App Review (budget a few days, more for Screen Time apps)

## Week 6, beta

- [ ] TestFlight build, 50 users
- [ ] Recruit: your SLC network, the local AI skill-building group, r/nosurf, r/digitalminimalism, Indie Hackers
- [ ] Run 6 weeks. Instrument day 30 hard, since that is where the category dies.
- [ ] **Go/no-go at the beta week 3 checkpoint (calendar week 9),** so the decision does not wait on data that arrives after submission: debrief completion at or above 50% and holding proceeds to submission prep. 35 to 50% means one round of friction reduction and a two week slip. Below 35% means rework before spend (D001's reversal condition).

## Weeks 7 to 10, monetize and polish (parallel with beta)

- [ ] StoreKit 2 + RevenueCat, one-time IAP + optional Sync subscription
- [ ] Supabase sync for the Sync tier, row-level security verified per table
- [ ] Sign in with Apple as the only login
- [ ] In-app account deletion with full server-side wipe (required once Sync creates accounts)
- [ ] Paywall after first debrief, with the "pay once" line, plus price, term, privacy policy, and EULA links
- [ ] Next.js marketing site on Vercel
- [ ] App Privacy nutrition label (accurate, minimal; policy and support pages went live in week 5)
- [ ] EU DSA trader verification started, or a deliberate US-first launch logged in DECISIONS.md

## Week 11, App Store submission

- [ ] Verify all five entitlements show **Distribution** in the portal, then regenerate every provisioning profile and rebuild. A main app approved while an extension sits on Development is the most common blocker in this API.
- [ ] Screenshots: gate, debrief with stamp, weekly review, home, adaptive gate
- [ ] Review notes: state plainly that this is a personal digital-wellbeing tool for the account holder's own device, that no data is collected for advertising, and that the app never blocks access
- [ ] Category: Health & Fitness, secondary Productivity
- [ ] Attach all IAPs to the build (one-time unlock, Sync monthly, Sync annual)
- [ ] Export compliance key (`ITSAppUsesNonExemptEncryption = NO`) in every target
- [ ] Submit with **manual release**, so approval can sit until the beta checkpoint confirms
- [ ] Budget 2 to 3 review cycles. Screen Time apps get extra scrutiny.

## Week 12, launch

Launch assets, in priority order:
1. **The reason cost table.** "Bored: 22 min. Reply: 3 min." This is the shareable artifact. Build a shareable card in-app.
2. Product Hunt, positioned as "the first screen time app that measures whether you meant it"
3. Show HN and r/nosurf, leading with the psychology base and the pay-once model
4. Outreach to digital wellbeing and productivity newsletters. The pay-once stance is your press angle: an app that refuses the subscription treadmill.
5. Beta users' IMS improvement charts, with permission, as social proof

## Distribution loop (weekly, from launch)

Launch week is an event; distribution is a system. The two shareable artifacts (the gate card and the reason cost table) are the raw material.

- One piece of short-form content per week built on a real artifact: a gate card render, a reason cost table, an IMS trend
- A handful of UGC creators in the digital wellbeing and productivity niche, seeded with the pay-once angle
- Paid acquisition only after organic conversion data exists. Buying users is allowed (the entitlement risk is collecting usage data for ads, which we never do); buying users before the funnel converts is just burning the runway.

## Post-launch

**V1.1 (month 2):** adaptive gate turns on, calibrated against real IMS data. Time-of-day patterns.
**V1.2 (month 4):** iPad, widgets, Shortcuts actions, ledger export.
**V2 (month 6+):** Android, evaluated only if iOS retention past day 30 holds.

## Retention watch

Instrument and review weekly: **percentage of week-1 users still logging debriefs at day 30.** Every friction competitor collapses here. If dialogue's curve flattens where theirs falls off, the adaptive gate thesis is validated and that number becomes the centerpiece of every pitch and press conversation.
