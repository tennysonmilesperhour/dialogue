# Family Controls entitlement

**Status: submitted 2026-08-19 for team T4PQ8SNY8D. Awaiting Apple's reply.**

## How the request actually works

Corrected on 2026-08-19 against the live form. See D016.

The request lives at
https://developer.apple.com/contact/request/family-controls-distribution
and it is much smaller than this file used to assume. It has:

- Name, email, and Team ID, all prefilled from the signed-in account
- The terms and conditions, reproduced below
- A single "Get Entitlement" button

There is no bundle ID field and no free-text use-case box. The entitlement is
granted **per developer team, not per bundle ID**, so one submission covers
every identifier under the team. The long use-case statement this file used to
carry had nowhere to be pasted, and has been removed rather than left to
mislead the next session.

Apple's response on submit: "We'll review your request and contact you soon
with a status update." So it is human-reviewed, not instant.

## Terms Apple binds you to

Quoted from the form. The app must have a primary purpose of either:

1. offering family controls for parents and guardians, through Family Sharing,
   to supervise their children's app usage; or
2. offering individuals the ability to manage their devices to enable focus and
   productivity through focus controls, timers and task management, or personal
   device usage management.

dialogue qualifies under 2, and only 2. Never describe it as a parental control
product, in the review notes, the store listing, or the category choice.

Further restrictions, all of which CONTEXT.md's non-negotiables already meet:

- May not be used for ad blocking, in organizational settings, or to manage the
  device of another adult individual.
- Device or usage data from the framework may be used only for providing the
  individual's own device management.
- That data may not be shared beyond the individual and their device, may not be
  used for advertising or advertising measurement, and may not be shared with a
  data broker.

## Registered identifiers

All five exist in the portal as of 2026-08-19, each with Family Controls
(Development) and App Groups enabled:

```
app.dialogue.ios                 Main app
app.dialogue.ios.shield          ShieldConfigurationExtension
app.dialogue.ios.shieldaction    ShieldActionExtension
app.dialogue.ios.monitor         DeviceActivityMonitorExtension
app.dialogue.ios.report          DeviceActivityReportExtension
```

Plus the App Group `group.app.dialogue`. These match `project.yml` and all five
`.entitlements` files exactly.

Gotcha when registering an App Group: the portal's Identifier field carries a
fixed `group.` prefix that cannot be deleted. Type only `app.dialogue` into it.
Typing the full `group.app.dialogue` produces `group.group.app.dialogue`.

The Development entitlement works in Xcode immediately and needs no approval.
The Distribution grant is what gates TestFlight and the App Store.

## Tracking

Submitted 2026-08-19. Check status weekly in the developer portal, under each
App ID's Capability Requests tab. Escalate through developer support after 10
days of silence, so by 2026-08-31.

## After approval

1. Confirm Family Controls (Distribution) shows as granted for the team, and
   that each of the five App IDs reflects it.
2. Regenerate all provisioning profiles, then archive clean.
3. A main app on Distribution with any extension still on Development is the
   most common cause of a blocked submission in this API. Check all five, every
   release.
