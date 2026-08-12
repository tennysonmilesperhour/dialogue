# App Review notes (draft)

*Paste into the Review Notes field in App Store Connect at submission.
Screen Time apps get extra scrutiny; the notes should preempt the three
assumptions reviewers commonly make: that this is a blocker, that it is a
parental control app, and that usage data is being collected.*

---

dialogue is a personal digital wellbeing tool for the account holder's own
device. It is not a parental control app and cannot monitor anyone else.

Three things reviewers usually ask about this category:

1. **dialogue never blocks apps.** The shield screen is a question, not a
   wall. The user can always proceed into the app they opened. There is no
   lockout mode anywhere in the product.

2. **No usage data is collected.** App selections are opaque Screen Time
   tokens; we cannot see which apps the user picked. Nothing about usage
   leaves the device. The only server-stored data is the user's own written
   entries, and only if they explicitly create the optional Sync account.
   There is no advertising and no analytics SDK that collects usage data.

3. **Screen Time authorization is required for core function.** The app
   requests FamilyControls authorization (individual, not parent/guardian)
   during onboarding because presenting the gate requires it.

## Demo script

1. Complete onboarding: grant Screen Time authorization when prompted.
2. Pick any app in the picker (Safari works), give it a short label when
   asked, accept the default reason chips and soft budget.
3. Open the picked app. The gate appears. Choose a reason to proceed, or
   "Never mind" to leave. Both paths work; neither is ever blocked.
4. Use the app briefly, then leave it. Open dialogue again: the debrief card
   asks whether the session matched the stated reason. Two taps completes it.
5. The home screen now shows the app row with its Intention Match Score.

The paywall appears after the first completed debrief. The free tier (one
watched app, full gate and debrief) remains fully functional without
purchase, so the core loop above is reviewable at no cost.

## Account deletion

Settings, first screen: Delete account removes the Supabase account and all
synced rows immediately. (Only relevant if a Sync account was created.)
