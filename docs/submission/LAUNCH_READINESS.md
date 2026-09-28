# Launch readiness

Build audited September 4, 2026. Reconciled against main September 28, 2026
at commit 67f6df5.

The September 4 audit ran on a Mac with Xcode. The September 28 pass did not:
it reconciled this list against what later commits actually changed, and every
build claim below still rests on the September audit. Re-run
`scripts/verify_release.sh` on the submission commit before trusting them
again.

This is the source of truth for whether dialogue can be submitted. A green
build is necessary, but it is not the same as a releasable product.

## Current verdict

**Build 2 is ready for signed archive and physical-device validation.** The
repository produces the complete local-first product loop and a valid
device-SDK release build with the five expected targets, release identifiers,
privacy manifests, export compliance declarations, and App Store icon.

The critical path is the physical-device Screen Time prototype, D012. No
physical iPhone was connected during this audit, so the reason handoff,
re-arm behavior, callback latency, and real shield presentation remain
unverified. The repository's own plan correctly blocks production work on
that result.

## Changed since the September 4 audit

- **Waitlist backend moved** to the active shared project (#12, 2026-09-07).
- **TestFlight lane added** (#13, 2026-09-27). `fastlane signed_archive` and
  `fastlane beta`, plus an upload job that skips until the secrets exist.
- **Extension privacy manifests corrected** (2026-09-28). The audit checked
  that a manifest was embedded in every bundle, which was true, but not what
  it declared. All four extensions reach app group user defaults through
  `SharedDialogueStore` while declaring no accessed API at all, which Apple
  rejects as ITMS-91053 after upload. Every extension now declares the user
  defaults category with reason CA92.1, and `verify_release.sh` asserts the
  declaration in each built bundle so it cannot regress. The report extension
  declares it too: it does not call the store itself, but it links DialogueKit
  which does, and an over-declaration is cheap while a missing one costs a
  review cycle.
- **PR #11 is still open and now conflicts with main.** Opened 2026-09-06 as a
  draft, 51 files, last touched 2026-09-07, based on a commit two merges back.
  Its web half was overtaken by #12, which landed the waitlist route
  differently, and GitHub reports the branch as conflicted. Its iOS half has
  not been superseded and is worth rescuing: it serializes the shared store
  behind a file lock, which matters because five processes currently
  read-modify-write the same defaults key with no coordination and a lost
  update silently drops a session or a dismissal. It also adds
  `docs/submission/DEVICE_ACCEPTANCE.md`, which is the device script D012
  needs. Decide deliberately: rebase the iOS half onto main, or close the PR
  and re-derive those two pieces. Leaving it open and stale is the one option
  that costs something.

## Verified in the repository

- [x] Xcode 26.5 and the iOS 26.5 SDK build all five targets in Release.
- [x] DialogueKit has 21 passing tests.
- [x] Product copy lint passes.
- [x] The Next.js 16.3.4 production build passes on Node.js 24.
- [x] `npm audit --audit-level=high` reports no vulnerabilities.
- [x] Main app and four extension bundle identifiers match the registered
      identifiers in D017.
- [x] Team ID `T4PQ8SNY8D` is set across generated targets.
- [x] V1 advertises iPhone support only.
- [x] Version is `1.0.0` with build number `2`.
- [x] Onboarding requests Screen Time access and configures named watched apps.
- [x] The shield records walk-aways and routes users to intention capture.
- [x] Sessions unshield one app, close at the soft budget, and queue a debrief.
- [x] The main app includes the ledger, IMS home, usage summary, weekly reason
      table, adaptive gate tiers, pause, watched-app editing, and local deletion.
- [x] `ITSAppUsesNonExemptEncryption` is false in every built bundle.
- [x] A privacy manifest is embedded in every built bundle.
- [x] Every entitlement file has Family Controls and `group.app.dialogue`.
- [x] The 1024 by 1024 App Store icon has no alpha channel.
- [x] Marketing, privacy, and support routes return HTTP 200.

Run the same checks with:

```bash
scripts/verify_release.sh
```

The GitHub Actions workflow also exposes a manual full release verification
run. Normal pull requests use the device SDK in Release and run the web
dependency audit.

## P0 submission blockers

- [ ] Run `Prototype/CloseDetectionLab` on a physical iPhone for a full day
      and record D012 in `docs/DECISIONS.md`.
- [x] Replace the phase 0 Home smoke test with the real onboarding, watched
      app setup, reason handoff, session ledger, two-tap debrief, IMS home,
      weekly review, and settings flows.
- [ ] Confirm the Family Controls Distribution entitlement is approved for
      team `T4PQ8SNY8D`. Submitted August 19, 2026, no reply as of September
      28. Escalation was due August 31 and has not been filed. This is the
      oldest open item on the project and it gates TestFlight as well as the
      App Store. Draft escalation text is in `ENTITLEMENT_REQUEST.md`.
- [ ] Produce a signed App Store archive with distribution provisioning for
      the app and all four extensions. The mechanism now exists:
      `fastlane signed_archive` builds it against the five named profiles, and
      `fastlane beta` uploads it (D018, `fastlane/README.md`). Neither has ever
      run, because both need the entitlement above, an App Store Connect API
      key, and the distribution certificate.
- [x] Create the App Store Connect app record and choose the store name
      `dialogue: intention ledger`.
- [x] Keep 1.0 free and local-only. StoreKit, accounts, Sync, RevenueCat, and
      third-party analytics are outside this build and must not appear in the listing.
- [ ] Capture the five 1320 by 2868 App Store screenshots from the finished
      product.
- [ ] Complete the current age-rating questionnaire and final App Privacy
      answers against the uploaded binary.
- [ ] Verify Screen Time authorization, shield, reason handoff, debrief, and
      data deletion behavior on the oldest supported iPhone.

## External service blockers

- [x] Replace Supabase project `ptwxbkzulstocpfhufea`. Closed 2026-09-07 (#12):
      the waitlist moved to the active shared Vibe Check project
      `xyhbuqsxglfjbounogdz`, table `dialogue_waitlist`, INSERT only, written
      through the server route. The paused project was kept rather than
      restored, so historical waitlist entries have not been recovered and
      should be treated as lost unless someone restores it deliberately.
- [x] Redeploy the website. The `dialogue` Vercel project has a READY
      production deployment from 2026-09-07, matching the backend move.
      Unresolved underneath it: the two most recent production deployments
      carry no commit metadata, which is what a CLI deploy looks like, while
      an earlier one does. Confirm in the project settings whether pushes to
      main now deploy on their own, because a site that only updates when
      someone remembers to run a command will drift from the repository.
- [ ] Add a private support channel before public launch. GitHub Issues is a
      working interim contact, but users should not post private ledger data
      there.
- [ ] Complete agreements, banking, tax, DSA trader status or a US-only
      availability decision, and the Small Business Program application in
      App Store Connect.
- [ ] Obtain trademark clearance or ship the qualified store name from D014.

## Current Apple requirements checked

- Since April 28, 2026, uploads require Xcode 26 or later and an iOS 26 SDK:
  https://developer.apple.com/news/upcoming-requirements/
- Privacy manifests must be valid and declare required-reason API use:
  https://developer.apple.com/documentation/bundleresources/privacy-manifest-files
- Apps that create accounts must let users initiate deletion in the app:
  https://developer.apple.com/support/offering-account-deletion-in-your-app/
- App Store screenshots accept one to ten images. The 6.9 inch iPhone 17 Pro
  Max portrait size is 1320 by 2868 pixels:
  https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/

## Definition of ready

Ready means all P0 blockers are closed, `scripts/verify_release.sh` passes on
the submission commit, a signed archive validates in Organizer, every promised
feature is visible and functional in that archive, the store listing matches
the binary, and the final build has passed a physical-device smoke test.
