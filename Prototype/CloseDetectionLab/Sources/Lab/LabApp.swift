import SwiftUI
import UserNotifications

@main
struct LabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Question 1: did a notification tap deep link us in?
                    LabLog.append(source: "app", name: "opened_via_url", detail: url.absoluteString)
                }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        ReasonNotification.registerCategory()
        return true
    }

    // Question 2: a chip action arrives here, in the background, without the
    // app coming to the foreground. Log the reason and open the grace window.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let action = response.actionIdentifier
        LabLog.append(source: "app", name: "notification_response", detail: action)
        if action.hasPrefix(ReasonNotification.chipActionPrefix) {
            let reason = String(action.dropFirst(ReasonNotification.chipActionPrefix.count))
            GraceController.shared.begin(reason: reason)
        } else if action == UNNotificationDefaultActionIdentifier {
            // Body tap: the notification-hop variant. onOpenURL logs arrival.
            GraceController.shared.begin(reason: "via_app_open")
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
