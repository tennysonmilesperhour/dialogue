import SwiftUI

@main
struct DialogueApp: App {
    @UIApplicationDelegateAdaptor(DialogueNotifications.self) private var notifications
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
