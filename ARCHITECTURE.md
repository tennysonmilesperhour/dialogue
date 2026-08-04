# ARCHITECTURE.md

## Stack

| Layer | Choice | Note |
|---|---|---|
| App | Swift / SwiftUI, iOS 17+ | Not React Native. Screen Time API is native-only. |
| Interception | FamilyControls, ManagedSettings, DeviceActivity | Requires Apple entitlement per bundle ID |
| Local store | SwiftData | Source of truth. App works fully offline. |
| Sync / auth | Supabase | Optional account. Ledger backup and web review. |
| Web | Next.js on Vercel | Marketing site, weekly review, support pages |
| Payments | StoreKit 2 + RevenueCat | RevenueCat for paywall testing and entitlement management |
| Analytics | TelemetryDeck | Privacy-first, no IDFA, no ATT prompt needed |

## Targets and bundle IDs

Every one of these needs its own Family Controls entitlement request. This is the most commonly missed step and the most common cause of a blocked App Store submission.

```
app.dialogue.ios                 Main app
app.dialogue.ios.shield          ShieldConfigurationExtension   (the gate card)
app.dialogue.ios.shieldaction    ShieldActionExtension          (Enter / Never mind)
app.dialogue.ios.monitor         DeviceActivityMonitorExtension (session events)
app.dialogue.ios.report          DeviceActivityReportExtension  (usage figures)
```

All five share a **App Group** (`group.app.dialogue`) for the shared SwiftData container. Extensions are memory-constrained (roughly 6MB for shield extensions), so they must write minimal records and let the main app do computation.

## The interception flow

**Gate (on open)**
1. `AuthorizationCenter.requestAuthorization(for: .individual)` at onboarding.
2. `FamilyActivityPicker` returns opaque `ApplicationToken`s. We never learn which apps the user picked, by design.
3. `ManagedSettingsStore.shield.applications = tokens` shields the selected apps.
4. `ShieldConfigurationExtension` renders the gate. **Constraint: Apple's shield configuration is a fixed template (icon, title, subtitle, primary button, secondary button), not arbitrary SwiftUI.** The full chip picker cannot live on the shield itself.

**Resolution:** the shield shows the app name, the user's reminder line as the subtitle, "Never mind" as the primary button, and "Choose a reason" as secondary. Secondary fires the `ShieldActionExtension`, which opens dialogue via deep link where the full chip card renders natively. Selecting a chip writes the session record and clears the shield for that token for a grace window (default 90 seconds), then re-arms.

Design the extra hop as a feature: choosing a reason costs a hop, dismissing costs nothing. That asymmetry is aligned with the product's goal.

**Session**
Silent. `DeviceActivitySchedule` with `eventDidReachThreshold` set to the soft budget, used only for recording, not for interrupting.

**Debrief (on close)**
The hard problem. iOS gives no reliable "user closed app X" callback.

Three layers, in order of preference:
1. **Re-arm detection.** When the grace window expires and the shield re-arms, we timestamp it. Close time approximates to the earlier of shield re-arm or budget threshold event.
2. **Threshold event.** `DeviceActivityMonitor.eventDidReachThreshold` at the soft budget fires a local notification: "How did that Instagram session go?" Tapping opens the debrief prefilled.
3. **Next-unlock catch.** If neither fires, the debrief surfaces as a card at the top of Home the next time dialogue opens, with "about 14 minutes" instead of an exact figure.

Session length is honestly labeled as approximate wherever layer 1 was not the source. Do not fake precision.

**Prototype gate for week one:** before writing production Swift, validate layers 1 and 2 on a real device with a throwaway app. If close detection proves unusable, the fallback product is a notification-driven debrief, which is weaker but still differentiated. This decision cannot be deferred.

## Data model

```
apps
  id, app_token (opaque, local only), display_name, soft_budget_seconds,
  reminder_line, reason_chips[], gate_tier, created_at

sessions
  id, app_id, reason, entered_at, closed_at, close_source (enum: rearm|threshold|inferred),
  verdict (yes|partly|no|unlogged), note, created_at

dismissals
  id, app_id, occurred_at, gate_tier

weekly_reviews
  id, week_start, ims_by_app (json), pattern_key, generated_at
```

IMS is **always derived, never stored raw**:

```
IMS(app, 14d) = (yes_count + 0.5 * partly_count) / (yes + partly + no)
```

Unlogged sessions are excluded from the numerator and denominator, never counted as failures. Punishing non-response would train users to avoid the debrief, which kills the product.

## Adaptive gate

| IMS (rolling 14d) | Tier | Behavior |
|---|---|---|
| 85%+ | whisper | Reason chips only, no delay |
| 60 to 85% | standard | Chips + reminder line + 3s settle |
| below 60% | deliberate | Chips + reminder + type one word + 8s delay |

Rules: minimum 12 logged sessions before tier moves off standard. Tier changes at most once per 72 hours to prevent thrash. The app always explains the change in plain language. Access is never revoked at any tier.

**Ship static standard tier in V1.** Adaptation turns on in V1.1 once real IMS distributions exist to calibrate against.

## Privacy posture

- App tokens are opaque by Apple's design. dialogue cannot enumerate installed apps.
- Reasons, verdicts, and notes are user-authored content, stored locally, synced only with an account.
- No third-party SDKs with data-sharing terms. No ad networks. Ever.
- This is not only ethics. Apple explicitly reviews entitlement requests for whether you are collecting usage data for advertising or profiling. Any ad SDK risks the entitlement.

## Repo layout

```
dialogue/
  Dialogue/              main app
  DialogueShield/        shield configuration extension
  DialogueShieldAction/  shield action extension
  DialogueMonitor/       device activity monitor extension
  DialogueReport/        device activity report extension
  DialogueKit/           shared package: models, IMS math, design tokens
  web/                   Next.js marketing + review
  docs/                  these files
```

Keep IMS math and design tokens in `DialogueKit` so the extensions and app never drift.
