import DeviceActivity
import ManagedSettings
import Foundation

/// Candidate B for re-arm, and the timestamp source for close detection.
/// Every callback logs immediately; comparing these timestamps against real
/// behavior over a day is the entire point of the lab.
class MonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        LabLog.append(source: "monitor", name: "intervalDidStart", detail: activity.rawValue)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        LabLog.append(source: "monitor", name: "intervalDidEnd", detail: activity.rawValue)
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)
        LabLog.append(source: "monitor", name: "eventDidReachThreshold", detail: event.rawValue)
        if event.rawValue == "rearm", let selection = LabSelection.load() {
            store.shield.applications = selection.applicationTokens
            LabLog.append(source: "monitor", name: "reshielded", detail: "threshold_event")
        }
    }
}
