import Foundation

/// The user's exit verdict on a session. Unlogged sessions are never counted
/// as failures anywhere in the product; punishing non-response trains users
/// to avoid the debrief.
public enum Verdict: String, Codable, Sendable, CaseIterable {
    case yes
    case partly
    case no
    case unlogged
}

/// How a session's close time was determined. Everything except `rearm` is
/// approximate and must be labeled as such in UI.
public enum CloseSource: String, Codable, Sendable {
    case rearm
    case threshold
    case inferred
}

public struct SessionRecord: Codable, Sendable, Identifiable, Equatable {
    public let id: UUID
    public let appID: UUID
    public var reason: String
    public var enteredAt: Date
    public var closedAt: Date?
    public var closeSource: CloseSource?
    public var verdict: Verdict
    public var note: String?
    /// Snapshot for ledger history after an app is no longer watched.
    public var appDisplayName: String?
    /// The DeviceActivity name used to close this session. Kept as a string
    /// so the shared model stays available to the macOS test target.
    public var monitorActivityName: String?

    public init(
        id: UUID = UUID(),
        appID: UUID,
        reason: String,
        enteredAt: Date,
        closedAt: Date? = nil,
        closeSource: CloseSource? = nil,
        verdict: Verdict = .unlogged,
        note: String? = nil,
        monitorActivityName: String? = nil,
        appDisplayName: String? = nil
    ) {
        self.id = id
        self.appID = appID
        self.reason = reason
        self.enteredAt = enteredAt
        self.closedAt = closedAt
        self.closeSource = closeSource
        self.verdict = verdict
        self.note = note
        self.monitorActivityName = monitorActivityName
        self.appDisplayName = appDisplayName
    }
}

public struct WatchedApp: Codable, Sendable, Identifiable, Equatable {
    public let id: UUID
    /// User-entered at setup. Screen Time tokens expose no app name to us,
    /// so this label is the only name the product can print.
    public var displayName: String
    public var reminderLine: String
    public var reasonChips: [String]
    public var softBudgetSeconds: Int
    public var gateTier: GateTier
    public var tierChangedAt: Date?
    public var createdAt: Date
    /// JSON-encoded ManagedSettings.ApplicationToken. Tokens are opaque by
    /// design, so the user's own display name remains the visible identity.
    public var applicationTokenData: Data?

    public init(
        id: UUID = UUID(),
        displayName: String,
        reminderLine: String = "",
        reasonChips: [String] = DefaultChips.standard,
        softBudgetSeconds: Int = 10 * 60,
        gateTier: GateTier = .standard,
        tierChangedAt: Date? = nil,
        createdAt: Date = Date(),
        applicationTokenData: Data? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.reminderLine = reminderLine
        self.reasonChips = reasonChips
        self.softBudgetSeconds = softBudgetSeconds
        self.gateTier = gateTier
        self.tierChangedAt = tierChangedAt
        self.createdAt = createdAt
        self.applicationTokenData = applicationTokenData
    }
}

public struct Dismissal: Codable, Sendable, Identifiable, Equatable {
    public let id: UUID
    public let appID: UUID
    public var occurredAt: Date
    public var gateTier: GateTier

    public init(id: UUID = UUID(), appID: UUID, occurredAt: Date, gateTier: GateTier) {
        self.id = id
        self.appID = appID
        self.occurredAt = occurredAt
        self.gateTier = gateTier
    }
}

/// Honest reasons are first-class and never punished at the gate. If honest
/// answers are punished, users learn to lie, and lied-to data makes IMS
/// worthless.
public enum DefaultChips {
    public static let standard = ["Reply", "Look up", "Post", "Bored", "Avoiding something"]
}
