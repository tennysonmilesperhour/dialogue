# Family Controls entitlement request

Submit one request per bundle ID at
https://developer.apple.com/contact/request/family-controls-distribution
after enrolling in the Apple Developer Program and registering the bundle IDs.
All five must be requested, the same day. The development entitlement can be
enabled in Xcode immediately and does not require approval; the distribution
entitlement below is what gates TestFlight and the App Store.

## Bundle IDs to request

```
app.dialogue.ios                 Main app
app.dialogue.ios.shield          ShieldConfigurationExtension
app.dialogue.ios.shieldaction    ShieldActionExtension
app.dialogue.ios.monitor         DeviceActivityMonitorExtension
app.dialogue.ios.report          DeviceActivityReportExtension
```

If Apple has renamed or restructured the request form since this was written,
the substance below still applies; adapt the fields.

## Use-case statement (paste for each bundle ID)

> dialogue is a personal digital wellbeing app for the account holder's own
> device. The user chooses apps they want to be more intentional about. When
> they open one, dialogue shows a brief screen asking why they are opening it,
> and when the session ends it asks whether that reason held up. The app keeps
> a private, on-device record of these answers and computes an Intention Match
> Score from them.
>
> dialogue never blocks access to any app. The shield is used only to present
> a question; the user can always proceed. This is not a parental control
> product and has no remote monitoring of any kind. There is exactly one user:
> the device owner, managing their own attention.
>
> We use FamilyControls for authorization and app selection,
> ManagedSettings/ManagedSettingsUI to present the gate screen, and
> DeviceActivity to observe session boundaries on device. App selections are
> opaque tokens; dialogue cannot and does not enumerate the user's apps.
>
> No usage data is collected for advertising or profiling. No usage data
> leaves the device at all. The only data that can sync to our servers is the
> user's own written entries (their stated reasons, verdicts, and notes), and
> only if they explicitly create an optional account. There are no ad SDKs
> and no data brokers in the app, and there never will be.

## Per-extension notes

- **shield** (`.shield`): renders the gate card UI on the shield using
  ManagedSettingsUI. Display only.
- **shieldaction** (`.shieldaction`): handles the two shield buttons (proceed
  or dismiss). Writes a minimal local record of the choice.
- **monitor** (`.monitor`): observes DeviceActivity schedule and threshold
  events to approximate session boundaries, locally.
- **report** (`.report`): renders Apple-computed usage figures inside the
  app. Display only; no data leaves the extension.

## Form answers likely to be asked

- Collects usage data for advertising: **No**
- Shares data with third parties: **No**
- Parental control features: **No, single-user personal tool**
- Target audience: adults managing their own device use

## After approval

1. Confirm every one of the five bundle IDs shows the Distribution
   entitlement in the developer portal.
2. Regenerate all provisioning profiles, then archive clean.
3. A main app on Distribution with any extension still on Development is the
   most common cause of a blocked submission in this API. Check all five,
   every release.

## Tracking

Log the submission date for each bundle ID in docs/DECISIONS.md. Check status
weekly. Escalate through developer support after 10 days of silence. Approval
reports range from about four business days to several weeks.
