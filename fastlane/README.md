# Shipping dialogue

Two lanes, one signing path.

```bash
fastlane signed_archive   # signed App Store archive in build/, uploads nothing
fastlane beta             # the same archive, then TestFlight
```

`brew install fastlane` and `brew install xcodegen` first. Every merge to main
runs `fastlane beta` from CI, but only once the secrets below exist. Until
then the upload job skips itself and CI stays green, so nothing here changes
the current pull request checks.

## What the lanes assume

- The five App Store provisioning profiles already exist in the developer
  portal under exactly the names in `Fastfile`, matching the
  `PROVISIONING_PROFILE_SPECIFIER` values in `project.yml`. The lanes download
  profiles, they never create them.
- The team holds an Apple Distribution certificate. Nothing here mints one:
  a team gets few of them, and a CI job that quietly creates certificates will
  exhaust the limit.
- The Family Controls Distribution entitlement is approved for team
  `T4PQ8SNY8D`. Every TestFlight build is distribution-signed, so an
  unapproved entitlement fails at upload, not at launch. Status is tracked in
  `docs/DECISIONS.md` (D016).

## One-time setup

**1. App Store Connect API key.** In App Store Connect, Users and Access,
Integrations, create a Team Key with the App Manager role. Download the `.p8`
once, then base64 it:

```bash
base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
```

**2. Distribution certificate.** In Keychain Access, export the Apple
Distribution identity (the certificate and its private key together) as a
`.p12` with a password, then base64 it:

```bash
base64 -i distribution.p12 | pbcopy
```

Keep both files out of the repository. They are credentials, not config.

**3. Repository secrets.** In GitHub, Settings, Secrets and variables,
Actions:

| Secret | Value |
|---|---|
| `ASC_KEY_ID` | the API key's Key ID |
| `ASC_ISSUER_ID` | the Issuer ID shown above the key list |
| `ASC_KEY_P8` | base64 of the `.p8` |
| `DIST_CERT_P12` | base64 of the `.p12` |
| `DIST_CERT_PASSWORD` | the password set during export |

The upload job checks for all five and skips cleanly if any is missing.

## Running the lanes locally

The same environment variables drive a local run, minus the certificate ones:
locally the lanes use the identity already in your keychain and never import
anything or touch a temporary keychain.

```bash
export ASC_KEY_ID=...
export ASC_ISSUER_ID=...
export ASC_KEY_P8="$(base64 -i AuthKey_XXXXXXXXXX.p8)"
fastlane signed_archive
```

## Build numbers

A local archive uses `CURRENT_PROJECT_VERSION` from `project.yml`, which is
what `scripts/verify_release.sh` asserts against. CI passes the workflow run
number through `DIALOGUE_BUILD_NUMBER` instead, because TestFlight rejects a
build number it has already accepted and run numbers only climb. Reasoning in
`docs/DECISIONS.md` (D018).

## What this does not do

It does not submit for review, distribute to external testers, or manage the
store listing. Beta App Review and the submission checklist stay manual, per
`docs/PLAN.md` section 4 and `docs/submission/LAUNCH_READINESS.md`.
