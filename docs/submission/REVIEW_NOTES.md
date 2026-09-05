# App Review notes

Paste the content below into the Review Notes field for build 2.

---

dialogue is a personal digital wellbeing tool for the account holder's own
iPhone. It is not a parental control app and cannot monitor anyone else.

Three implementation details may help review:

1. dialogue never permanently locks an app. The shield is a reflective gate.
   "Never mind" closes the attempted visit. "Choose a reason" opens dialogue
   so the user can name an intention and begin the visit. All gates can also
   be paused in Settings.

2. No data is collected. App selections are opaque Screen Time tokens. The
   user's labels, reasons, verdicts, and notes remain in the local App Group.
   The app has no account, advertising, analytics SDK, purchase SDK, or Sync.

3. Screen Time authorization is required for the core function. The app
   requests FamilyControls authorization for the individual account during
   onboarding because presenting and removing the gate requires it.

## Demo script

1. Complete onboarding and grant Screen Time authorization.
2. Pick any individual app in the picker, give it a short label and optional
   reminder, then choose a soft budget.
3. Open the picked app. On the shield, tap "Choose a reason." On iOS versions
   before 26.5, tap the immediate notification or open dialogue manually.
4. In dialogue, choose a reason, wait for the brief settle timer, and tap the
   button to begin the visit. Return to the selected app; it is now available.
5. To complete the loop immediately, return to dialogue and tap "End visit
   and reflect" on Today. Choose Yes, Partly, or No. The entry appears in the
   Ledger and updates the Intention Match Score.
6. Review shows Screen Time in watched apps, average duration and match rate
   by reason. Settings includes pause, watched-app editing, privacy links, and
   complete local data deletion.

The complete build is free and has no sign-in, demo account, paywall, in-app
purchase, or subscription.
