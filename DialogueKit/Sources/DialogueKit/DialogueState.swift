import Foundation

public struct PendingGateRequest: Codable, Sendable, Equatable {
    public var applicationTokenData: Data
    public var requestedAt: Date

    public init(applicationTokenData: Data, requestedAt: Date = Date()) {
        self.applicationTokenData = applicationTokenData
        self.requestedAt = requestedAt
    }
}

public struct DialogueState: Codable, Sendable, Equatable {
    public var watchedApps: [WatchedApp]
    public var sessions: [SessionRecord]
    public var dismissals: [Dismissal]
    public var onboardingCompleted: Bool
    public var isPaused: Bool
    public var pendingDebriefIDs: [UUID]

    public init(
        watchedApps: [WatchedApp] = [],
        sessions: [SessionRecord] = [],
        dismissals: [Dismissal] = [],
        onboardingCompleted: Bool = false,
        isPaused: Bool = false,
        pendingDebriefIDs: [UUID] = []
    ) {
        self.watchedApps = watchedApps
        self.sessions = sessions
        self.dismissals = dismissals
        self.onboardingCompleted = onboardingCompleted
        self.isPaused = isPaused
        self.pendingDebriefIDs = pendingDebriefIDs
    }
}

/// The intentionally small shared record used by the app and extensions.
/// Fresh encoders avoid shared mutable state across extension processes.
public enum SharedDialogueStore {
    private static let stateKey = "dialogue.state.v1"
    private static let pendingGateKey = "dialogue.pending-gate.v1"

    public static func load() -> DialogueState {
        guard
            let data = AppGroup.sharedDefaults?.data(forKey: stateKey),
            let state = try? JSONDecoder().decode(DialogueState.self, from: data)
        else { return DialogueState() }
        return state
    }

    public static func save(_ state: DialogueState) {
        guard let defaults = AppGroup.sharedDefaults,
              let data = try? JSONEncoder().encode(trimmed(state))
        else { return }
        defaults.set(data, forKey: stateKey)
    }

    public static func setPendingGate(_ request: PendingGateRequest) {
        guard let defaults = AppGroup.sharedDefaults,
              let data = try? JSONEncoder().encode(request)
        else { return }
        defaults.set(data, forKey: pendingGateKey)
    }

    public static func consumePendingGate() -> PendingGateRequest? {
        guard let defaults = AppGroup.sharedDefaults,
              let data = defaults.data(forKey: pendingGateKey),
              let request = try? JSONDecoder().decode(PendingGateRequest.self, from: data)
        else { return nil }
        defaults.removeObject(forKey: pendingGateKey)
        return request
    }

    public static func reset() {
        AppGroup.sharedDefaults?.removeObject(forKey: stateKey)
        AppGroup.sharedDefaults?.removeObject(forKey: pendingGateKey)
    }

    private static func trimmed(_ state: DialogueState) -> DialogueState {
        var result = state
        result.sessions = Array(result.sessions.sorted { $0.enteredAt > $1.enteredAt }.prefix(1_000))
        result.dismissals = Array(result.dismissals.sorted { $0.occurredAt > $1.occurredAt }.prefix(1_000))
        return result
    }
}
