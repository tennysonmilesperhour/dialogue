import DialogueKit
import FamilyControls
import Foundation
import Combine
import UserNotifications

@MainActor
final class DialogueModel: ObservableObject {
    @Published private(set) var state: DialogueState
    @Published private(set) var authorizationStatus: AuthorizationStatus
    @Published var gateAppID: UUID?
    @Published var debriefSessionID: UUID?
    @Published var errorMessage: String?

    private let screenTime = ScreenTimeCoordinator()

    init() {
        let loaded = SharedDialogueStore.load()
        state = loaded
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        screenTime.applyShields(to: loaded)
        routePendingRequests()
    }

    var gateApp: WatchedApp? {
        state.watchedApps.first { $0.id == gateAppID }
    }

    var debriefSession: SessionRecord? {
        state.sessions.first { $0.id == debriefSessionID }
    }

    var activeSession: SessionRecord? {
        state.sessions.first { $0.closedAt == nil }
    }

    var hasScreenTimeAuthorization: Bool {
        if authorizationStatus == .approved { return true }
        if #available(iOS 26.4, *), authorizationStatus == .approvedWithDataAccess { return true }
        return false
    }

    func requestAuthorization() async {
        errorMessage = nil
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
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
        state.watchedApps = apps
        state.onboardingCompleted = !apps.isEmpty
        state.isPaused = false
        persistAndApply()
    }

    func replaceWatchedApps(_ apps: [WatchedApp]) {
        state.watchedApps = apps
        persistAndApply()
    }

    func refreshFromSharedState() {
        state = SharedDialogueStore.load()
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus

        routePendingRequests()
        screenTime.applyShields(to: state)
    }

    func beginSession(reason: String) {
        guard let app = gateApp else { return }
        errorMessage = nil

        if let current = activeSession {
            closeSession(current.id, source: .inferred)
        }

        let sessionID = UUID()
        var session = SessionRecord(
            id: sessionID,
            appID: app.id,
            reason: reason,
            enteredAt: Date(),
            appDisplayName: app.displayName
        )
        state.sessions.insert(session, at: 0)
        SharedDialogueStore.save(state)

        do {
            session.monitorActivityName = try screenTime.beginSession(
                for: app,
                sessionID: sessionID,
                state: state
            )
            if let index = state.sessions.firstIndex(where: { $0.id == sessionID }) {
                state.sessions[index] = session
            }
            SharedDialogueStore.save(state)
            gateAppID = nil
        } catch {
            state.sessions.removeAll { $0.id == sessionID }
            SharedDialogueStore.save(state)
            errorMessage = error.localizedDescription
        }
    }

    func endActiveSession() {
        guard let activeSession else { return }
        closeSession(activeSession.id, source: .rearm)
        debriefSessionID = activeSession.id
    }

    func submitDebrief(verdict: Verdict, note: String?) {
        guard let id = debriefSessionID,
              let index = state.sessions.firstIndex(where: { $0.id == id })
        else { return }
        state.sessions[index].verdict = verdict
        let cleaned = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        state.sessions[index].note = cleaned?.isEmpty == true ? nil : cleaned
        state.pendingDebriefIDs.removeAll { $0 == id }
        debriefSessionID = nil
        updateTier(for: state.sessions[index].appID)
        persistAndApply()
    }

    func deferDebrief() {
        debriefSessionID = nil
    }

    func setPaused(_ paused: Bool) {
        state.isPaused = paused
        persistAndApply()
    }

    func deleteAllData() {
        for session in state.sessions {
            screenTime.stopMonitoring(named: session.monitorActivityName)
        }
        SharedDialogueStore.reset()
        state = DialogueState()
        gateAppID = nil
        debriefSessionID = nil
        screenTime.applyShields(to: state)
    }

    func appName(for session: SessionRecord) -> String {
        session.appDisplayName ??
        state.watchedApps.first(where: { $0.id == session.appID })?.displayName ??
        "Unknown app"
    }

    private func closeSession(_ id: UUID, source: CloseSource) {
        guard let index = state.sessions.firstIndex(where: { $0.id == id }),
              state.sessions[index].closedAt == nil
        else { return }
        state.sessions[index].closedAt = Date()
        state.sessions[index].closeSource = source
        if !state.pendingDebriefIDs.contains(id) {
            state.pendingDebriefIDs.append(id)
        }
        screenTime.stopMonitoring(named: state.sessions[index].monitorActivityName)
        persistAndApply()
    }

    private func updateTier(for appID: UUID) {
        guard let appIndex = state.watchedApps.firstIndex(where: { $0.id == appID }) else { return }
        let sessions = state.sessions.filter { $0.appID == appID }
        let current = state.watchedApps[appIndex].gateTier
        let next = GateTier.next(
            current: current,
            ims: IMS.score(sessions: sessions),
            loggedSessions: IMS.loggedCount(sessions: sessions),
            lastChangedAt: state.watchedApps[appIndex].tierChangedAt
        )
        if next != current {
            state.watchedApps[appIndex].gateTier = next
            state.watchedApps[appIndex].tierChangedAt = Date()
        }
    }

    private func routePendingRequests() {
        if let request = SharedDialogueStore.consumePendingGate(),
           Date().timeIntervalSince(request.requestedAt) < 10 * 60,
           let app = state.watchedApps.first(where: {
               $0.applicationTokenData == request.applicationTokenData
           }) {
            gateAppID = app.id
        }

        if gateAppID == nil,
           debriefSessionID == nil,
           let pendingID = state.pendingDebriefIDs.first,
           state.sessions.contains(where: { $0.id == pendingID && $0.verdict == .unlogged }) {
            debriefSessionID = pendingID
        }
    }

    private func persistAndApply() {
        SharedDialogueStore.save(state)
        screenTime.applyShields(to: state)
    }
}
