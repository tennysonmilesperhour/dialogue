import Foundation

/// The one app group every target shares. Extensions are memory constrained
/// (roughly 6MB for the shield), so they never spin up the SwiftData
/// container. DialogueFileStore serializes ledger updates across processes.
public enum AppGroup {
    public static let identifier = "group.app.dialogue"

    /// Nil when the app group is missing from the target's entitlements,
    /// which is the single most common cause of a silently broken extension.
    /// Callers treat nil as "not configured" and say so out loud rather than
    /// failing quietly.
    public static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: identifier)
    }

    /// The shared container on disk, for the record stores that outgrow
    /// defaults. Nil for the same reason as above.
    public static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }
}
