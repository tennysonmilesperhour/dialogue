# Physical-device release acceptance

Status: not run. No connected iPhone was available on September 7, 2026.
Do not substitute simulator or unsigned-build results for these checks.

Record the tested commit, installed build, iPhone model, iOS version, date,
result, and any observed callback delays. Test the exact distribution candidate
through TestFlight after signing is available. Include the oldest supported iOS
version where practical, and both sides of the iOS 26.5 handoff change.

| Check | Required result | Result |
| --- | --- | --- |
| Fresh launch | Onboarding is readable; no storage error | Pending |
| Authorization denied | Clear recovery route; existing apps remain usable | Pending |
| Authorization granted | Individual app picker and labels save correctly | Pending |
| Gate handoff | Selected app shows gate; Choose a reason reaches dialogue, directly on iOS 26.5 or by notification/manual launch earlier | Pending |
| Notifications denied | Manual opening of dialogue still completes the pending gate | Pending |
| Intentional visit | Only the chosen app opens; refresh does not re-shield the active visit | Pending |
| Budget callback | Visit closes and gate returns; record actual delay with app backgrounded and phone locked | Pending |
| Manual finish | End visit and reflect closes the visit and permits a verdict | Pending |
| Reflection recovery | Later and relaunch preserve unlogged entries; recording a verdict consumes it once | Pending |
| Concurrent callbacks | Repeated gate, monitor, and app actions preserve every completed entry | Pending |
| Pause | Every watched app opens; pause survives relaunch | Pending |
| Delete | Ledger, selections, reminders, monitors, notifications, and shields clear; relaunch remains empty | Pending |
| Revoke Screen Time | Reopening dialogue provides recovery without trapping another app | Pending |
| Accessibility | VoiceOver names controls; large text and small-screen layouts remain usable | Pending |
| Offline | Complete the local app flow with networking unavailable | Pending |
| Privacy | Lock-screen notifications disclose no app label, intention, or note | Pending |
| Full-day D012 | Record handoff, re-arm reliability, callback latency, and limitations in DECISIONS.md | Pending |

After a passing run, capture real product screenshots from the release
candidate and attach them to the store listing. Re-run affected checks after
any candidate change. Keep the screenshot ledger fictional and do not expose
personal intentions or app selections.
