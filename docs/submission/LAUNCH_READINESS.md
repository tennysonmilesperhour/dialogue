# Launch readiness

Release candidate: 1.0.0 (3), prepared October 6, 2026.

## Verdict

The local-first product is implemented. App Store submission is **not yet
verified**. Build success and sample-ledger screenshots do not establish that
Apple has approved distribution or that Screen Time works on a real device.

## Implemented

- Progressive welcome and app setup, with a public fictional sample held in
  memory so the product can be explored before granting permissions.
- Always-available gate continuation, optional suggested pauses, built-in and
  custom intentions, soft-budget monitoring, and manual visit completion.
- Two-tap reflection, optional notes, defer, undo, and later editing.
- Searchable ledger with a pending-reflections filter.
- Seven-day review, per-day reflection chart, reason summaries, prior-week
  comparison, and a separate Apple Screen Time usage report.
- CSV and JSON exports that exclude app tokens and internal monitor IDs.
- Opt-in reflection notifications and Sunday 6 pm review reminders, with no
  personal content in lock-screen notifications.
- System light/dark appearance, Dynamic Type, labeled controls, generous tap
  targets, scrollable layouts, and reduced-motion-aware feedback.
- Local data deletion, pause/resume, recovery copy, and an in-app field guide.
- Bounded monotonic file locking, preserving corrupt data instead of replacing
  it, with concurrent-writer, timeout, and export/calculation tests.
- Correct App Group defaults reason 1C8F.1 and timer reason 35F9.1 in all five
  privacy manifests. The previous CA92.1 mapping was incorrect; see D020.
- Support and privacy contacts aligned to morphiclabsdata@gmail.com.
- Website and prepared store listing match the free, local-only 1.0 scope.
  Website analytics are disclosed separately from the native app.
- A signed archive/TestFlight lane and UI checks in the upload dependency gate.

## Verification record

Results for the final candidate are recorded below after the checks complete.
Use `swift test --package-path DialogueKit`, `scripts/verify_ui.sh`, and
`scripts/verify_release.sh` to reproduce them. The UI results include actual
app screenshots with fictional sample entries.

## Remaining release gates

1. **Family Controls Distribution approval.** The repo records the August 19
   request but contains no approval evidence. Check Apple's current account
   status and confirm distribution support for all five identifiers.
2. **Provisioning and signed archive.** This Mac has an Apple Distribution
   identity, but no Dialogue App Store profiles were found. The five named
   profiles in `project.yml` must be available. GitHub's signing secrets are
   not configured. A signed archive must validate before upload.
3. **Physical iPhone acceptance.** No iPhone was connected during this work.
   Every physical check in DEVICE_ACCEPTANCE.md remains pending, including
   real gate handoff, callbacks with the phone locked, revocation, deletion,
   offline use, and full-day reliability. Test both the oldest supported OS
   and the iOS 26.5+ handoff where practical.
4. **App Store Connect completion.** Verify the app record, final privacy and
   age-rating answers, screenshots, review contact, availability, and current
   agreements. The app is free and has no IAPs; monetization enrollment is not
   a prerequisite for this version. Apple dashboard state was not verified.
5. **Publish and verify public pages.** Deploy the reviewed website update,
   confirm the support/privacy routes and contact, and test the production
   waitlist without adding unsolicited addresses.

Do not mark the app ready to submit until those gates have evidence from the
same final candidate. Do not replace physical results with simulator checks.
