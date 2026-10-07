import DialogueKit
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
    @Published var pending: (String, String?)?
}

struct ReminderInvitation: View {
    @ObservedObject var model: DialogueModel
    @State private var requesting = false
    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DialogueHeader(kicker: "Your ledger is ready", title: "A reminder\nto look back?")
                    Text("A quiet notification can bring you back to your reflection after a visit. It never shows an app name or anything you wrote.")
                        .font(.system(.title3, design: .serif)).lineSpacing(4)
                    LedgerCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("dialogue", systemImage: "bell").font(.system(.caption, design: .monospaced))
                            Text("How did that visit go?").font(.system(.headline, design: .serif))
                            Text("Your reflection is ready in dialogue.").font(.system(.body, design: .serif))
                        }
                    }
                    Button(requesting ? "Requesting permission…" : "Enable reflection reminders") {
                        requesting = true
                        Task {
                            await model.requestNotifications()
                            model.offerReminders = false
                        }
                    }.buttonStyle(LedgerButtonStyle()).disabled(requesting)
                    Button("Not now") { model.offerReminders = false }
                        .font(.system(.body, design: .serif)).frame(maxWidth: .infinity, minHeight: 48)
                    Text("You can always reflect from your ledger. Change notifications later in Settings.")
                        .font(.system(.footnote, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                }.padding(.vertical, 30)
            }
        }
    }
}
