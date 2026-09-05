# Launch readiness

Last audited September 4, 2026.

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
      team `T4PQ8SNY8D`. The request was submitted August 19, 2026.
- [ ] Produce a signed App Store archive with distribution provisioning for
      the app and all four extensions.
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

- [ ] Restore or replace Supabase project `ptwxbkzulstocpfhufea`. It is
      inactive, database requests time out, and the live waitlist cannot
      accept signups. The Supabase account connected during this audit does
      not own that project, so it cannot restore it.
- [ ] Redeploy the website after the database is healthy. The Vercel project
      is not connected to Git, so pushes do not deploy automatically.
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
