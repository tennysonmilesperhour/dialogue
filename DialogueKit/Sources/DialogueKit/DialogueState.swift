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

extension DialogueState {
    /// Derive the queue from valid, closed entries so a stale ID cannot hide later reflections.
    public var pendingDebriefs: [SessionRecord] {
        sessions.filter { $0.closedAt != nil && $0.verdict == .unlogged }
            .sorted { $0.enteredAt > $1.enteredAt }
    }

    public var activeAppIDs: Set<UUID> {
        Set(sessions.filter { $0.closedAt == nil }.map(\.appID))
    }

    public var shieldedAppIDs: Set<UUID> {
        guard !isPaused else { return [] }
        return Set(watchedApps.map(\.id)).subtracting(activeAppIDs)
    }

    public mutating func normalize() {
        sessions = Array(sessions.sorted { $0.enteredAt > $1.enteredAt }.prefix(1_000))
        dismissals = Array(dismissals.sorted { $0.occurredAt > $1.occurredAt }.prefix(1_000))
        pendingDebriefIDs = pendingDebriefs.map(\.id)
    }
}
