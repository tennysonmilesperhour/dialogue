import SwiftUI
import UserNotifications

@MainActor
final class NotificationSettings: ObservableObject {
    @Published var status: UNAuthorizationStatus = .notDetermined
    @Published var weeklyEnabled = false
    @Published var message: String?
    private let center = UNUserNotificationCenter.current()
    private let weeklyID = "dialogue.weekly-review"

    func refresh() async {
        status = await center.notificationSettings().authorizationStatus
        weeklyEnabled = await center.pendingNotificationRequests().contains { $0.identifier == weeklyID }
    }

    func enableVisitReminders() async {
        do { _ = try await center.requestAuthorization(options: [.alert, .sound]) }
        catch { message = "Notifications could not be enabled. You can still reflect from your ledger." }
        await refresh()
    }

    func setWeekly(_ enabled: Bool) async {
        if !enabled {
            center.removePendingNotificationRequests(withIdentifiers: [weeklyID])
            await refresh()
            return
        }
        do {
            guard try await center.requestAuthorization(options: [.alert, .sound]) else {
                message = "Allow notifications in iPhone Settings to receive a weekly reminder."
                await refresh()
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "A moment with your week"
            content.body = "Your private weekly review is ready in dialogue."
            content.userInfo = ["route": "review"]
            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 18, minute: 0, weekday: 1), repeats: true)
            try await center.add(UNNotificationRequest(identifier: weeklyID, content: content, trigger: trigger))
        } catch { message = "The weekly reminder could not be saved. Please try again." }
        await refresh()
    }
}

final class DialogueNotifications: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        let route = info["route"] as? String ?? "reflection"
        // The response may arrive before the root view subscribes during a cold launch.
        Task { @MainActor in
            NotificationRoute.shared.pending = (route, info["sessionID"] as? String)
            completionHandler()
        }
    }
}

@MainActor
final class NotificationRoute: ObservableObject {
    static let shared = NotificationRoute()
    @Published var pending: (String, String)?
}
