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

Verified October 7, 2026:

- All 29 DialogueKit tests pass, including concurrent writers, bounded locking,
  recovery, seven-day calculations, and safe exports.
- All application and extension targets build with the device SDK, and the
  physical-device prototype builds.
- The full release verification script passes: bundle identifiers, version,
  iPhone-only device family, icon, all four embedded extensions, privacy
  manifests, entitlements, encryption declaration, web build, and dependency audit.
- The website production build and TypeScript checks pass. Fonts are bundled
  under their OFL licenses, removing a network dependency during builds.
- Public home, support, and privacy routes return HTTP 200. Support/privacy
  show morphiclabsdata@gmail.com, and invalid waitlist emails return HTTP 400.
- All four iPhone interface tests pass on the first attempt, with zero failures:
  intention/reflection/undo/search, maximum Dynamic Type, dark review, and
  pause/resume. The sample entries are fictional. The unsigned-runner storage
  recovery alert is explicitly acknowledged before the welcome capture.
  Screenshots are preserved in the `dialogue-interface-results` CI artifact.

The final code revision 7b3fc59 passed CI:
https://github.com/tennysonmilesperhour/dialogue/actions/runs/37581459562

The full release-bundle audit passed at 77d0039:
https://github.com/tennysonmilesperhour/dialogue/actions/runs/37578680214/job/112653701821
Subsequent changes affect website typography and the UI-test harness, including
an appearance override compiled only in DEBUG. The shipping native behavior
and release configuration are unchanged. The signed archive and physical
acceptance gates below are separate from these checks.

Use `swift test --package-path DialogueKit`, `scripts/verify_ui.sh`, and
`scripts/verify_release.sh` to reproduce the checks.

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
   a prerequisite for this version. App Store Connect was signed out when
   checked, so Apple dashboard state could not be verified.

## Public website

Published and checked at https://dialogue-five.vercel.app, including `/support`
and `/privacy`. The waitlist validation test did not add an email address.
The successful registration path still needs a controlled, consenting tester
before beta invitations are sent.

Do not mark the app ready to submit until those gates have evidence from the
same final candidate. Do not replace physical results with simulator checks.
