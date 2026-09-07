# Launch readiness

Last audited September 7, 2026.

September 6 audit adds serialized local persistence, reflection recovery,
active-visit shield preservation, generic notifications, a working web preview,
and a protected server signup endpoint. See `../AUDIT-2026-09-06.md` for findings
and validation. The live Supabase hostname did not resolve during a read-only
check; no live service or deployment was changed. Configure Turnstile and the
server credentials, and coordinate the waitlist migration with the website
release before reopening signups. All physical-device and signing gates below
remain open until separately verified.

This is the source of truth for whether dialogue can be submitted. A green
build is necessary, but it is not the same as a releasable product.

## Current verdict

**Not ready for submission. Build 2 still needs signing and device validation.** The
repository produces the complete local-first product loop and a valid
device-SDK release build with the five expected targets, release identifiers,
privacy manifests, export compliance declarations, and App Store icon.

The critical path is the physical-device Screen Time prototype, D012. No
physical iPhone was connected during this audit, so the reason handoff,
re-arm behavior, callback latency, and real shield presentation remain
unverified. The repository's own plan correctly blocks production work on
that result.

## Verified in the repository

- [x] Xcode 26.6 and the iOS 26.5 SDK build all five targets in Release.
- [x] DialogueKit has 27 passing tests, including bounded lock contention recovery.
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

## Store access and public support

- [ ] Add a private support channel before public launch. GitHub Issues is a
      working interim contact, but users should not post private ledger data
      there.
- [ ] Sign in to App Store Connect and resolve any required account agreements
      and the applicable DSA status and territory settings. Banking, tax, and
      Small Business enrollment are not blanket prerequisites for this free
      build; inspect what the account actually requires.
- [ ] Obtain trademark clearance or ship the qualified store name from D014.

## Optional website waitlist

The app does not depend on the waitlist. Keep signups paused until the database
is restored, the access-control migration is applied, and server credentials
and Turnstile are configured. Deploy those changes together. The Vercel
project was previously not connected to Git, so a push alone is insufficient.
Public support and privacy pages must remain available regardless of signups.

## September 7 submission attempt

- Apple Distribution certificate is present for team `T4PQ8SNY8D`.
- No Dialogue provisioning profiles are installed. Automatic development
  signing failed for all five targets: the team has no registered devices.
- No physical iPhone was detected by `devicectl`.
- App Store Connect browser session requires sign-in. Store data and the
  Family Controls distribution approval could not be verified.
- Live privacy and support URLs returned HTTP 200.
- No binary was uploaded and no review submission was made.

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
