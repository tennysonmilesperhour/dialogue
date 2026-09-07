import DeviceActivity
import DialogueKit
import Foundation
import ManagedSettings

struct ScreenTimeCoordinator {
    private let center = DeviceActivityCenter()

    func applyShields(to state: DialogueState) {
        DialogueShieldController.apply(state)
    }

    func beginSession(for app: WatchedApp, sessionID: UUID) throws -> String {
        guard let token = ScreenTimeTokenCodec.decode(app.applicationTokenData)
        else { throw ScreenTimeError.missingToken }

        let activity = DeviceActivityName(DialogueScreenTime.activityPrefix + sessionID.uuidString)
        let start = Date().addingTimeInterval(2)
        let end = start.addingTimeInterval(Double(max(app.softBudgetSeconds + 60, 15 * 60)))
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        let schedule = DeviceActivitySchedule(
            intervalStart: calendar.dateComponents(components, from: start),
            intervalEnd: calendar.dateComponents(components, from: end),
            repeats: false
        )
        let threshold = DateComponents(second: max(app.softBudgetSeconds, 60))
        let event: DeviceActivityEvent
        if #available(iOS 17.4, *) {
            event = DeviceActivityEvent(
                applications: [token],
                threshold: threshold,
                includesPastActivity: false
            )
        } else {
            event = DeviceActivityEvent(applications: [token], threshold: threshold)
        }

        try center.startMonitoring(
            activity,
            during: schedule,
            events: [DeviceActivityEvent.Name(DialogueScreenTime.budgetEventName): event]
        )
        do {
            try SharedDialogueStore.update { DialogueShieldController.apply($0) }
        } catch {
            center.stopMonitoring([activity])
            throw error
        }
        return activity.rawValue
    }

    func stopAllMonitoring() {
        center.stopMonitoring(center.activities.filter { $0.rawValue.hasPrefix(DialogueScreenTime.activityPrefix) })
    }

    func stopMonitoring(named rawName: String?) {
        guard let rawName else { return }
        center.stopMonitoring([DeviceActivityName(rawName)])
    }
}

enum ScreenTimeError: LocalizedError {
    case missingToken

    var errorDescription: String? {
        "This app's Screen Time token is no longer available. Choose it again in Settings."
    }
}
