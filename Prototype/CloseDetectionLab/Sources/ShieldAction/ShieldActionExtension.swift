import ManagedSettings

/// The extension cannot open the containing app; its whole vocabulary is
/// close, defer, none. "Choose a reason" therefore posts the notification
/// and defers, keeping the shield up until a chip (or the app) clears it.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            // "Never mind." Dismissing costs nothing, by design.
            LabLog.append(source: "shieldaction", name: "never_mind")
            completionHandler(.close)
        case .secondaryButtonPressed:
            LabLog.append(source: "shieldaction", name: "choose_reason_tapped")
            ReasonNotification.post()
            completionHandler(.defer)
        @unknown default:
            completionHandler(.none)
        }
    }
}
