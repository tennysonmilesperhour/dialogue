# ROADMAP.md

## Critical path

Two things gate everything and both must start on day one:

1. **Family Controls entitlement requests, all five bundle IDs.** Requests are per bundle ID and every Screen Time extension needs its own. Approval runs from about four business days to several weeks and is reviewed manually. Development entitlement works locally in the meantime, so submitting early costs nothing and submitting late costs the launch.
2. **Close-detection prototype.** If iOS cannot tell us when a session ended, the debrief degrades and the product changes shape. Answer this in week one, before writing production code.

---

## Week 0, setup (2 days)

- [ ] Apple Developer Program enrollment active, Small Business Program applied (15% rate)
- [ ] Register all five bundle IDs (see ARCHITECTURE.md)
- [ ] Submit Family Controls (Distribution) request for each, with a clear digital-wellbeing use case and an explicit statement that no usage data is collected for advertising or profiling
- [ ] USPTO + App Store name clearance on "dialogue"
- [ ] Secure domain and social handles
- [ ] Repo initialized with these docs in `/docs`

## Week 1, de-risk

- [ ] Throwaway prototype: shield an app, render a custom shield, capture Enter and Never mind actions
- [ ] Test all three close-detection layers on a physical device across a full day
- [ ] **Gate decision:** does layer 1 (re-arm timestamp) give usable session lengths? Log the answer in DECISIONS.md before proceeding.
- [ ] Design the gate card at production fidelity within the shield template's real constraints

## Weeks 2 to 4, core build

- [ ] Onboarding: authorization, FamilyActivityPicker, reminder line, chip setup, soft budgets
- [ ] Gate: shield config + shield action + deep link to chip card
- [ ] Debrief: verdict, stat line, note, stamp animation
- [ ] Home: app rows with IMS, never-mind streak
- [ ] `DialogueKit`: IMS math, SwiftData models, design tokens
- [ ] Local-only. No Supabase yet.

## Week 5, review layer

- [ ] Weekly review screen: IMS trend, reason cost table, one rule-based pattern
- [ ] Sunday evening local notification
- [ ] TelemetryDeck instrumentation on the four beta metrics (debrief completion, dismissal rate, retention, IMS trend)

## Week 6, beta

- [ ] TestFlight build, 50 users
- [ ] Recruit: your SLC network, the local AI skill-building group, r/nosurf, r/digitalminimalism, Indie Hackers
- [ ] Run 6 weeks. Instrument day 30 hard, since that is where the category dies.
- [ ] **Go/no-go:** debrief completion above 50% proceeds. Below 35% means rework before spend.

## Weeks 7 to 10, monetize and polish (parallel with beta)

- [ ] StoreKit 2 + RevenueCat, one-time IAP + optional Sync subscription
- [ ] Supabase sync for the Sync tier
- [ ] Paywall after first debrief, with the "pay once" line
- [ ] Next.js marketing site on Vercel
- [ ] Privacy policy, support page, App Privacy nutrition label (accurate, minimal)

## Week 11, App Store submission

- [ ] Verify all five entitlements show **Distribution** in the portal, then regenerate every provisioning profile and rebuild. A main app approved while an extension sits on Development is the most common blocker in this API.
- [ ] Screenshots: gate, debrief with stamp, weekly review, home, adaptive gate
- [ ] Review notes: state plainly that this is a personal digital-wellbeing tool for the account holder's own device, that no data is collected for advertising, and that the app never blocks access
- [ ] Category: Health & Fitness, secondary Productivity
- [ ] Budget 2 to 3 review cycles. Screen Time apps get extra scrutiny.

## Week 12, launch

Launch assets, in priority order:
1. **The reason cost table.** "Bored: 22 min. Reply: 3 min." This is the shareable artifact. Build a shareable card in-app.
2. Product Hunt, positioned as "the first screen time app that measures whether you meant it"
3. Show HN and r/nosurf, leading with the psychology base and the pay-once model
4. Outreach to digital wellbeing and productivity newsletters. The pay-once stance is your press angle: an app that refuses the subscription treadmill.
5. Beta users' IMS improvement charts, with permission, as social proof

## Post-launch

**V1.1 (month 2):** adaptive gate turns on, calibrated against real IMS data. Time-of-day patterns.
**V1.2 (month 4):** iPad, widgets, Shortcuts actions, ledger export.
**V2 (month 6+):** Android, evaluated only if iOS retention past day 30 holds.

## Retention watch

Instrument and review weekly: **percentage of week-1 users still logging debriefs at day 30.** Every friction competitor collapses here. If dialogue's curve flattens where theirs falls off, the adaptive gate thesis is validated and that number becomes the centerpiece of every pitch and press conversation.
