import SwiftUI

@main
struct DialogueApp: App {
    @UIApplicationDelegateAdaptor(DialogueNotifications.self) private var notifications
    var body: some Scene {
        WindowGroup {
            HomeView()
                #if DEBUG
                // UI screenshots exercise real dynamic colors with a deterministic appearance.
                .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("-test-dark-appearance") ? .dark : nil)
                #endif
        }
    }
}
