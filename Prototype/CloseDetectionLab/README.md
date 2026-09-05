# CloseDetectionLab

The week-1 throwaway prototype. It exists to answer four questions on a
physical device, and then to be deleted. Nothing here ships.

## The four questions (log answers in docs/DECISIONS.md as D012)

1. **The hop.** Can the shield action extension hand off to our app at all?
   There is no openURL in extensions; the lab posts a local notification
   from the action extension. Measure: does the notification arrive, how
   fast, and how many taps to a logged reason.
2. **Notification-action chips.** The same notification carries the reason
   chips as action buttons. Does tapping a chip log the reason and clear the
   shield without opening the app? Is the long-press-to-see-actions gesture
   acceptable?
3. **Re-arm mechanics.** After clearing the shield, what actually re-arms
   it: the app-side 90 second timer (dies when the app backgrounds), or the
   one minute usage-threshold event handled in the monitor extension? What
   is the real latency on the threshold callback?
4. **Template fidelity.** Does the ledger aesthetic land within Apple's
   fixed shield template (background, icon, title, subtitle, two buttons)?

Every event in every process appends to a shared timeline you can read and
export from the app. Carry the phone for a full day and export the log.

## Setup

1. `brew install xcodegen`, then `xcodegen generate` in this directory.
2. Open `CloseDetectionLab.xcodeproj`. Team `T4PQ8SNY8D` is already set.
3. In Signing & Capabilities, confirm each target shows Family Controls
   (Development) and the `group.app.dialogue` App Group.
4. Run on a physical device (Screen Time APIs do not work in the simulator).
5. In the app: request authorization, pick one victim app (Safari is fine),
   grant notifications, start monitoring, then shield.

The lab deliberately uses the registered production bundle IDs so it can run
without four more portal records. Installing it replaces the phase 0 dialogue
app on the device. Reinstall the main project when testing is complete.

If Xcode rejects an extension at launch, diff the generated Info.plist
NSExtension entries against a fresh Xcode template of the same extension
type; Apple occasionally renames these.

## What "good" looks like

Layer 1 usable: re-arm timestamps within about a minute of real closes for
most sessions across the day. If only layers 2 and 3 hold, the product
shifts to the notification-driven debrief described in docs/INTENT.md.
