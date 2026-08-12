# dialogue privacy policy (draft)

*Draft for review before publication. Publish at the marketing site under
/privacy before external TestFlight. Plain language is the point; resist
legal boilerplate that obscures the actual posture.*

Effective date: to be set at publication.

## The short version

dialogue is a ledger you keep with yourself. Your reasons, verdicts, and
notes live on your device. We cannot see which apps you watch. We do not
collect usage data. We do not run ads, sell data, or profile you. If you
never create an account, nothing leaves your phone.

## What dialogue stores on your device

- The apps you chose to watch, as opaque system tokens. Apple designed these
  tokens so that dialogue cannot learn which apps they are. The names you see
  in dialogue are labels you typed yourself.
- Your reasons, verdicts, notes, reminder lines, and settings.
- Session records dialogue derives on your device (approximate start, end,
  and length).

All of this stays in the app's private storage. It is included in your normal
device backups under Apple's standard backup protections.

## What we collect if you do nothing

Anonymous, aggregate app health signals through TelemetryDeck (for example,
"a debrief was completed"), with no advertising identifier, no fingerprinting,
and no way to tie a signal to you. No account is required and none of your
entries are included.

## What changes if you create a Sync account

Sync is optional and off by default. If you create an account, your ledger
entries (reasons, verdicts, notes, and the labels you wrote) are encrypted in
transit and stored with our database provider (Supabase) so you can back up
and view your ledger on your other devices. App tokens never sync; they are
meaningless off your device.

You can delete your account and all synced data from inside the app at any
time. Deletion is immediate and complete on our side.

## Purchases

Payments are processed by Apple. We use RevenueCat to manage entitlements;
it receives purchase receipts, not your ledger.

## What we will never do

- Sell or share your data with anyone.
- Collect app usage data for advertising or profiling.
- Add advertising SDKs to the app.
- Read your ledger. It is yours.

## Children

dialogue is for adults managing their own devices. It is not directed at
children and has no parental control features.

## Contact

Questions to the support address published at the marketing site.

## Changes

If this policy changes, the app will say so plainly before the change takes
effect, and the diff will be public in this repository.
