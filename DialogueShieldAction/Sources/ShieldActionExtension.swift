import ManagedSettings

/// The two buttons on the gate card.
///
/// The extension's entire vocabulary is close, defer, and none. It has no
/// openURL, so "Choose a reason" cannot open dialogue directly. Which shape
/// the reason path takes (a notification whose tap deep links, or reason
/// chips riding as notification actions) is D012, which the week 1 prototype
/// decides. Phase 0 therefore keeps the responses and nothing else: dismiss
/// closes, the reason path defers so the shield stays up until something
/// clears it.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        completionHandler(response(to: action))
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        completionHandler(response(to: action))
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        completionHandler(response(to: action))
    }

    private func response(to action: ShieldAction) -> ShieldActionResponse {
        switch action {
        case .primaryButtonPressed:
            // "Never mind." Dismissing costs nothing, by design. Phase 2
            // records the dismissal here.
            return .close
        case .secondaryButtonPressed:
            return .defer
        @unknown default:
            return .none
        }
    }
}
