import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

/// Question 3: what actually re-arms the shield after a grace window opens?
/// Two candidates run side by side and both log, so a day of use shows which
/// one fired and how late.
final class GraceController {
    static let shared = GraceController()

    static let rearmEventName = DeviceActivityEvent.Name("rearm")
    static let activityName = DeviceActivityName("lab.day")

    private let store = ManagedSettingsStore()
    private var appSideTimer: Timer?

    /// Clears the shield, then races the two re-arm mechanisms.
    func begin(reason: String, graceSeconds: TimeInterval = 90) {
        LabLog.append(source: "app", name: "grace_begin", detail: reason)
        store.shield.applications = nil

        // Candidate A: app-side timer. Expected to die when we background,
        // which is precisely what the lab needs to demonstrate.
        appSideTimer?.invalidate()
        appSideTimer = Timer.scheduledTimer(withTimeInterval: graceSeconds, repeats: false) { _ in
            LabLog.append(source: "app", name: "rearm_app_timer_fired")
            self.rearm(via: "app_timer")
        }

        // Candidate B: one minute usage-threshold event; the monitor
        // extension re-shields in eventDidReachThreshold.
        startThresholdMonitoring()
    }

    func rearm(via source: String) {
        guard let selection = LabSelection.load() else { return }
        store.shield.applications = selection.applicationTokens
        LabLog.append(source: "app", name: "reshielded", detail: source)
    }

    func startThresholdMonitoring() {
        guard let selection = LabSelection.load() else { return }
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(minute: 1)
        )
        do {
            let center = DeviceActivityCenter()
            center.stopMonitoring([Self.activityName])
            try center.startMonitoring(
                Self.activityName,
                during: schedule,
                events: [Self.rearmEventName: event]
            )
            LabLog.append(source: "app", name: "monitoring_started")
        } catch {
            LabLog.append(source: "app", name: "monitoring_error", detail: String(describing: error))
        }
    }
}
