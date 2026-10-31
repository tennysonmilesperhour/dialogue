import Foundation

/// Friction as consequence, not constant. High IMS earns a lighter gate.
/// The adaptive tiers ship in 1.0: the app calls `next` whenever a reflection
/// is logged or edited. The rules live here so the app and extensions never
/// drift. The tier only sets the suggested pause; nothing is ever locked.
public enum GateTier: String, Codable, Sendable, CaseIterable {
    case whisper
    case standard
    case deliberate

    public static let whisperThreshold = 0.85
    public static let deliberateThreshold = 0.60
    public static let minimumLoggedSessions = 12
    public static let minimumSecondsBetweenChanges: TimeInterval = 72 * 3600

    /// Settle delay before Enter unlocks, in seconds.
    public var settleSeconds: Int {
        switch self {
        case .whisper: return 0
        case .standard: return 3
        case .deliberate: return 8
        }
    }

    /// Deliberate adds the type-one-word step.
    public var requiresTypedWord: Bool {
        self == .deliberate
    }

    /// The tier a given IMS points at, before guard rails.
    public static func target(forIMS ims: Double) -> GateTier {
        if ims >= whisperThreshold { return .whisper }
        if ims < deliberateThreshold { return .deliberate }
        return .standard
    }

    /// Applies the guard rails: minimum 12 logged sessions before the tier
    /// moves off standard, at most one change per 72 hours, and no movement
    /// at all without data. Access is never revoked at any tier; this only
    /// shapes the gate. The app must explain any change in plain language.
    public static func next(
        current: GateTier,
        ims: Double?,
        loggedSessions: Int,
        lastChangedAt: Date?,
        now: Date = Date()
    ) -> GateTier {
        guard let ims else { return current }
        guard loggedSessions >= minimumLoggedSessions else { return .standard }
        if let lastChangedAt, now.timeIntervalSince(lastChangedAt) < minimumSecondsBetweenChanges {
            return current
        }
        return target(forIMS: ims)
    }
}
