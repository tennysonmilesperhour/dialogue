import DeviceActivity
import DialogueKit
import Foundation
import UserNotifications

class MonitorExtension: DeviceActivityMonitor {
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        closeSession(for: activity, source: .inferred)
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)
        closeSession(for: activity, source: .threshold)
    }

    private func closeSession(for activity: DeviceActivityName, source: CloseSource) {
        guard let sessionID = DialogueScreenTime.sessionID(from: activity.rawValue) else { return }
        var closedSession: SessionRecord?
        do {
            try SharedDialogueStore.update { state in
                guard let index = state.sessions.firstIndex(where: { $0.id == sessionID }),
                      state.sessions[index].closedAt == nil else { return }
                state.sessions[index].closedAt = Date()
                state.sessions[index].closeSource = source
                closedSession = state.sessions[index]
                DialogueShieldController.apply(state)
            }
            guard let session = closedSession else { return }
            DeviceActivityCenter().stopMonitoring([activity])
            scheduleDebrief(for: session)
        } catch {
            DialogueShieldController.apply(DialogueState())
        }
    }

    private func scheduleDebrief(for session: SessionRecord) {
        let content = UNMutableNotificationContent()
        content.title = "How did that visit go?"
        content.body = "Your reflection is ready in dialogue."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: "dialogue.debrief.\(session.id.uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }
}
