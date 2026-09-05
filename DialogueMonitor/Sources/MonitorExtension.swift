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
        var state = SharedDialogueStore.load()
        guard let index = state.sessions.firstIndex(where: { $0.id == sessionID }),
              state.sessions[index].closedAt == nil
        else { return }

        state.sessions[index].closedAt = Date()
        state.sessions[index].closeSource = source
        if !state.pendingDebriefIDs.contains(sessionID) {
            state.pendingDebriefIDs.append(sessionID)
        }
        SharedDialogueStore.save(state)
        DialogueShieldController.apply(state)
        DeviceActivityCenter().stopMonitoring([activity])
        scheduleDebrief(for: state.sessions[index], state: state)
    }

    private func scheduleDebrief(for session: SessionRecord, state: DialogueState) {
        let appName = session.appDisplayName ??
            state.watchedApps.first(where: { $0.id == session.appID })?.displayName ??
            "that app"
        let content = UNMutableNotificationContent()
        content.title = "How did that visit go?"
        content.body = "Did your \(appName) visit match \(session.reason.lowercased())?"
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: "dialogue.debrief.\(session.id.uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }
}
