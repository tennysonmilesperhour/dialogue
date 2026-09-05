import DialogueKit
import Foundation
import ManagedSettings
import UserNotifications

class ShieldActionExtension: ShieldActionDelegate {
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        guard let tokenData = ScreenTimeTokenCodec.encode(application) else {
            completionHandler(.none)
            return
        }

        switch action {
        case .primaryButtonPressed:
            recordDismissal(for: tokenData)
            completionHandler(.close)
        case .secondaryButtonPressed:
            SharedDialogueStore.setPendingGate(PendingGateRequest(applicationTokenData: tokenData))
            if #available(iOS 26.5, *) {
                completionHandler(.openParentalControlsApp)
            } else {
                scheduleOpenDialogueNotification()
                completionHandler(.defer)
            }
        case .firstSecondarySubmenuItemPressed,
             .secondSecondarySubmenuItemPressed,
             .thirdSecondarySubmenuItemPressed:
            completionHandler(.defer)
        @unknown default:
            completionHandler(.none)
        }
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        completionHandler(action == .primaryButtonPressed ? .close : .defer)
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        completionHandler(action == .primaryButtonPressed ? .close : .defer)
    }

    private func recordDismissal(for tokenData: Data) {
        var state = SharedDialogueStore.load()
        guard let app = state.watchedApps.first(where: { $0.applicationTokenData == tokenData }) else { return }
        state.dismissals.insert(
            Dismissal(appID: app.id, occurredAt: Date(), gateTier: app.gateTier),
            at: 0
        )
        SharedDialogueStore.save(state)
    }

    private func scheduleOpenDialogueNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Choose your reason"
        content.body = "Open dialogue to begin this intentional visit."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: "dialogue.open-gate",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }
}
