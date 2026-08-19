import DeviceActivity
import Foundation

/// Session events, and the timestamp source for close detection.
///
/// Phase 2 hangs three things off these callbacks: the soft budget threshold
/// that fires the debrief notification, the re-arm that closes a grace
/// window, and the timestamps layer 1 grades sessions from. Which of those
/// the monitor actually owns is D012, so phase 0 registers the callbacks and
/// nothing else. Callbacks here routinely arrive minutes late, which is why
/// every session length in the product is labeled approximate.
class MonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)
    }
}
