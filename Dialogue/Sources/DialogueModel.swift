import DialogueKit
import FamilyControls
import Foundation
import Combine
import UserNotifications

@MainActor
final class DialogueModel: ObservableObject {
    @Published private(set) var state = DialogueState()
    @Published private(set) var authorizationStatus: AuthorizationStatus
    @Published var gateAppID: UUID?
    @Published var debriefSessionID: UUID?
    @Published var errorMessage: String?
    @Published var lastLoggedMessage: String?

    private let screenTime = ScreenTimeCoordinator()
    private var deferredIDs: Set<UUID> = []

    init() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        refreshFromSharedState()
    }

    var gateApp: WatchedApp? { state.watchedApps.first { $0.id == gateAppID } }
    var debriefSession: SessionRecord? { state.sessions.first { $0.id == debriefSessionID } }
    var activeSession: SessionRecord? { state.sessions.first { $0.closedAt == nil } }

    var hasScreenTimeAuthorization: Bool {
        if authorizationStatus == .approved { return true }
        if #available(iOS 26.4, *), authorizationStatus == .approvedWithDataAccess { return true }
        return false
    }

    func requestAuthorization() async {
        errorMessage = nil
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            refreshFromSharedState()
        } catch {
            errorMessage = "Screen Time access could not be enabled: \(error.localizedDescription)"
        }
    }

    func requestNotifications() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            errorMessage = "Notifications could not be enabled: \(error.localizedDescription)"
        }
    }

    func finishOnboarding(with apps: [WatchedApp]) {
        changeState {
            $0.watchedApps = apps
            $0.onboardingCompleted = !apps.isEmpty
            $0.isPaused = false
        }
    }

    func replaceWatchedApps(_ apps: [WatchedApp]) {
        let retained = Set(apps.map(\.id))
        var stopped: [String] = []
        if changeState({ state in
            for index in state.sessions.indices where state.sessions[index].closedAt == nil && !retained.contains(state.sessions[index].appID) {
                state.sessions[index].closedAt = Date()
                state.sessions[index].closeSource = .inferred
                if let name = state.sessions[index].monitorActivityName { stopped.append(name) }
            }
            state.watchedApps = apps
        }) {
            stopped.forEach { screenTime.stopMonitoring(named: $0) }
        }
    }

    func refreshFromSharedState() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        do {
            state = try SharedDialogueStore.update { DialogueShieldController.apply($0) }
            routePendingRequests()
        } catch { storageError() }
    }

    func beginSession(reason: String) {
        guard let app = gateApp else { return }
        errorMessage = nil
        let sessionID = UUID()
        let activityName = DialogueScreenTime.activityPrefix + sessionID.uuidString
        var stopped: [String] = []
        guard changeState({ state in
            for index in state.sessions.indices where state.sessions[index].closedAt == nil {
                state.sessions[index].closedAt = Date()
                state.sessions[index].closeSource = .inferred
                if let name = state.sessions[index].monitorActivityName { stopped.append(name) }
            }
            state.sessions.insert(SessionRecord(
                id: sessionID, appID: app.id, reason: reason, enteredAt: Date(),
                monitorActivityName: activityName, appDisplayName: app.displayName
            ), at: 0)
        }, applyShields: false) else { return }
        stopped.forEach { screenTime.stopMonitoring(named: $0) }
        do {
            _ = try screenTime.beginSession(for: app, sessionID: sessionID)
            gateAppID = nil
        } catch {
            // A monitoring failure must not trap the user behind a gate.
            if changeState({ $0.sessions.removeAll { $0.id == sessionID }; $0.isPaused = true }) {
                gateAppID = nil
                errorMessage = "The visit could not be monitored. Gates are paused so your apps remain available. Resume them in Settings when you are ready."
            }
        }
    }

    func dismissGate() {
        guard let app = gateApp else { return }
        if changeState({ $0.dismissals.insert(Dismissal(appID: app.id, occurredAt: Date(), gateTier: app.gateTier), at: 0) }) {
            gateAppID = nil
        }
    }

    func endActiveSession() {
        guard let session = activeSession else { return }
        if changeState({ state in
            guard let index = state.sessions.firstIndex(where: { $0.id == session.id }), state.sessions[index].closedAt == nil else { return }
            state.sessions[index].closedAt = Date()
            state.sessions[index].closeSource = .rearm
        }) {
            screenTime.stopMonitoring(named: session.monitorActivityName)
            debriefSessionID = session.id
        }
    }

    func submitDebrief(verdict: Verdict, note: String?) {
        guard let id = debriefSessionID, verdict != .unlogged else { return }
        let cleaned = String((note ?? "").trimmingCharacters(in: .whitespacesAndNewlines).prefix(2_000))
        guard changeState({ state in
            guard let index = state.sessions.firstIndex(where: { $0.id == id && $0.closedAt != nil }) else { return }
            state.sessions[index].verdict = verdict
            state.sessions[index].note = cleaned.isEmpty ? nil : cleaned
            Self.updateTier(for: state.sessions[index].appID, in: &state)
        }) else { return }
        removeNotification(for: id)
        debriefSessionID = nil
        lastLoggedMessage = "Logged. One more visit understood."
    }

    func deferDebrief() {
        if let id = debriefSessionID { deferredIDs.insert(id) }
        debriefSessionID = nil
    }

    func setPaused(_ paused: Bool) {
        var stopped: [String] = []
        if changeState({ state in
            state.isPaused = paused
            if paused {
                for index in state.sessions.indices where state.sessions[index].closedAt == nil {
                    state.sessions[index].closedAt = Date()
                    state.sessions[index].closeSource = .inferred
                    if let name = state.sessions[index].monitorActivityName { stopped.append(name) }
                }
            }
        }) {
            stopped.forEach { screenTime.stopMonitoring(named: $0) }
        }
    }

    func deleteAllData() {
        do {
            // Stop callbacks before clearing the record and remove lock-screen copies.
            screenTime.stopAllMonitoring()
            try SharedDialogueStore.reset()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            state = DialogueState()
            gateAppID = nil
            debriefSessionID = nil
            lastLoggedMessage = nil
            deferredIDs.removeAll()
            screenTime.applyShields(to: state)
        } catch { storageError() }
    }

    func appName(for session: SessionRecord) -> String {
        session.appDisplayName ?? state.watchedApps.first(where: { $0.id == session.appID })?.displayName ?? "Unknown app"
    }

    private static func updateTier(for appID: UUID, in state: inout DialogueState) {
        guard let index = state.watchedApps.firstIndex(where: { $0.id == appID }) else { return }
        let sessions = state.sessions.filter { $0.appID == appID }
        let current = state.watchedApps[index].gateTier
        let next = GateTier.next(current: current, ims: IMS.score(sessions: sessions),
                                 loggedSessions: IMS.loggedCount(sessions: sessions), lastChangedAt: state.watchedApps[index].tierChangedAt)
        if next != current {
            state.watchedApps[index].gateTier = next
            state.watchedApps[index].tierChangedAt = Date()
        }
    }

    private func routePendingRequests() {
        do {
            if let request = try SharedDialogueStore.consumePendingGate(),
               (0..<600).contains(Date().timeIntervalSince(request.requestedAt)),
               let app = state.watchedApps.first(where: { $0.applicationTokenData == request.applicationTokenData }) {
                debriefSessionID = nil
                gateAppID = app.id
            }
            if gateAppID == nil, debriefSessionID == nil,
               let pending = state.pendingDebriefs.first(where: { !deferredIDs.contains($0.id) }) {
                debriefSessionID = pending.id
            }
        } catch { storageError() }
    }

    @discardableResult
    private func changeState(_ change: (inout DialogueState) -> Void, applyShields: Bool = true) -> Bool {
        do {
            state = try SharedDialogueStore.update { current in
                change(&current)
                if applyShields { DialogueShieldController.apply(current) }
            }
            return true
        } catch {
            storageError()
            return false
        }
    }

    private func removeNotification(for id: UUID) {
        let ids = ["dialogue.debrief.\(id.uuidString)"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }

    private func storageError() {
        screenTime.applyShields(to: DialogueState())
        errorMessage = "Your ledger could not be opened or saved. Your existing entries have been kept. Gates are open while storage is unavailable. Try reopening dialogue."
    }
}
