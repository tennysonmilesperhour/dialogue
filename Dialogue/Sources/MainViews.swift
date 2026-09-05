import DialogueKit
import DeviceActivity
import ManagedSettings
import SwiftUI

struct MainTabs: View {
    @ObservedObject var model: DialogueModel

    var body: some View {
        TabView {
            TodayView(model: model)
                .tabItem { Label("Today", systemImage: "book.closed") }
            LedgerView(model: model)
                .tabItem { Label("Ledger", systemImage: "list.bullet.rectangle") }
            WeeklyReviewView(model: model)
                .tabItem { Label("Review", systemImage: "chart.bar") }
            SettingsView(model: model)
                .tabItem { Label("Settings", systemImage: "slider.horizontal.3") }
        }
    }
}

struct TodayView: View {
    @ObservedObject var model: DialogueModel

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        DialogueHeader(kicker: "Today", title: "Your intention ledger")
                        scoreCard
                        if let active = model.activeSession {
                            activeSessionCard(active)
                        }
                        if let pending = pendingSession {
                            pendingDebriefCard(pending)
                        }
                        startCard
                        perAppScores
                    }
                    .padding(.vertical, 22)
                }
                .refreshable { model.refreshFromSharedState() }
            }
            .navigationTitle("")
        }
    }

    private var scoreCard: some View {
        LedgerCard {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("INTENTION MATCH")
                        .font(.system(.caption, design: .monospaced, weight: .semibold))
                    Text("Last \(IMS.windowDays) days")
                        .font(.system(.caption, design: .serif))
                }
                Spacer()
                Text(scoreText(model.state.sessions))
                    .font(.system(size: 42, weight: .semibold, design: .monospaced))
                    .monospacedDigit()
                    .foregroundStyle(scoreColor(model.state.sessions))
            }
        }
    }

    private func activeSessionCard(_ session: SessionRecord) -> some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("ACTIVE VISIT")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundStyle(Color.ledgerGreen)
                Text(model.appName(for: session))
                    .font(.system(.title2, design: .serif, weight: .semibold))
                Text("Intention: \(session.reason)")
                    .font(.system(.body, design: .serif))
                Text("Switch back to the app. dialogue will re-arm at your soft budget.")
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(Color.ink.opacity(0.65))
                Button("End visit and reflect") { model.endActiveSession() }
                    .buttonStyle(.bordered)
            }
        }
    }

    private func pendingDebriefCard(_ session: SessionRecord) -> some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("ONE OPEN QUESTION")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundStyle(Color.ledgerRed)
                Text("Did your \(model.appName(for: session)) visit match \(session.reason.lowercased())?")
                    .font(.system(.title3, design: .serif))
                Button("Reflect now") { model.debriefSessionID = session.id }
                    .buttonStyle(.bordered)
            }
        }
    }

    private var startCard: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("START WITH AN INTENTION")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                Text("You can also open any watched app. Its shield will send you here.")
                    .font(.system(.body, design: .serif))
                ForEach(model.state.watchedApps) { app in
                    Button {
                        model.gateAppID = app.id
                    } label: {
                        HStack {
                            Text(app.displayName)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                    }
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(Color.ink)
                    .padding(.vertical, 5)
                }
            }
        }
    }

    private var perAppScores: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("BY APP")
                .font(.system(.caption, design: .monospaced, weight: .semibold))
            ForEach(model.state.watchedApps) { app in
                let sessions = model.state.sessions.filter { $0.appID == app.id }
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(app.displayName)
                            .font(.system(.body, design: .serif, weight: .semibold))
                        Text("\(IMS.loggedCount(sessions: sessions)) logged · \(app.gateTier.rawValue) gate")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(Color.ink.opacity(0.6))
                    }
                    Spacer()
                    Text(scoreText(sessions))
                        .font(.system(.title3, design: .monospaced, weight: .semibold))
                }
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) { Rectangle().fill(Color.ink.opacity(0.25)).frame(height: 1) }
            }
        }
    }

    private var pendingSession: SessionRecord? {
        guard let id = model.state.pendingDebriefIDs.first else { return nil }
        return model.state.sessions.first { $0.id == id && $0.verdict == .unlogged }
    }
}

struct LedgerView: View {
    @ObservedObject var model: DialogueModel

    var body: some View {
        NavigationStack {
            LedgerPage {
                Group {
                    if model.state.sessions.isEmpty {
                        ContentUnavailableView(
                            "No entries yet",
                            systemImage: "book.closed",
                            description: Text("Your first intentional app visit will appear here.")
                        )
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                DialogueHeader(kicker: "History", title: "The ledger")
                                    .padding(.vertical, 22)
                                ForEach(model.state.sessions.sorted { $0.enteredAt > $1.enteredAt }) { session in
                                    sessionRow(session)
                                }
                            }
                        }
                        .refreshable { model.refreshFromSharedState() }
                    }
                }
            }
            .navigationTitle("")
        }
    }

    private func sessionRow(_ session: SessionRecord) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline) {
                Text(model.appName(for: session))
                    .font(.system(.title3, design: .serif, weight: .semibold))
                Spacer()
                Text(session.enteredAt, format: .dateTime.month(.abbreviated).day().hour().minute())
                    .font(.system(.caption, design: .monospaced))
            }
            HStack {
                Text(session.reason)
                    .font(.system(.body, design: .serif))
                Spacer()
                Text(verdictLabel(session.verdict))
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundStyle(verdictColor(session.verdict))
            }
            Text(durationText(session))
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(Color.ink.opacity(0.62))
            if let note = session.note, !note.isEmpty {
                Text(note)
                    .font(.system(.body, design: .serif))
                    .italic()
            }
        }
        .padding(.vertical, 15)
        .overlay(alignment: .bottom) { Rectangle().fill(Color.ink).frame(height: 1) }
    }
}

struct WeeklyReviewView: View {
    @ObservedObject var model: DialogueModel

    private var recent: [SessionRecord] {
        let cutoff = Date().addingTimeInterval(-7 * 86_400)
        return model.state.sessions.filter { $0.enteredAt >= cutoff }
    }

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        DialogueHeader(kicker: "Seven days", title: "Weekly review")
                        reviewSummary
                        usageReport
                        reasonTable
                        patternPrompt
                    }
                    .padding(.vertical, 22)
                }
            }
            .navigationTitle("")
        }
    }

    private var reviewSummary: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            miniMetric("VISITS", "\(recent.count)")
            miniMetric("MATCH", scoreText(recent))
            miniMetric("WALKED AWAY", "\(recentDismissals)")
            miniMetric("UNLOGGED", "\(recent.filter { $0.verdict == .unlogged }.count)")
        }
    }

    private var usageReport: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("TIME IN WATCHED APPS")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                DeviceActivityReport(
                    DeviceActivityReport.Context(rawValue: "Total activity"),
                    filter: usageFilter
                )
                .frame(height: 62)
            }
        }
    }

    private var usageFilter: DeviceActivityFilter {
        let start = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let tokens: Set<ApplicationToken> = Set(model.state.watchedApps.compactMap {
            ScreenTimeTokenCodec.decode($0.applicationTokenData)
        })
        return DeviceActivityFilter(
            segment: .daily(during: DateInterval(start: start, end: Date())),
            applications: tokens
        )
    }

    private var reasonTable: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("REASONS")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                if reasonSummaries.isEmpty {
                    Text("Complete a visit to see which intentions recur.")
                        .font(.system(.body, design: .serif))
                } else {
                    HStack {
                        Text("Reason")
                        Spacer()
                        Text("Avg")
                            .frame(width: 48, alignment: .trailing)
                        Text("Match")
                            .frame(width: 60, alignment: .trailing)
                    }
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    ForEach(reasonSummaries) { item in
                        HStack {
                            Text(item.reason).font(.system(.body, design: .serif))
                            Spacer()
                            Text(item.averageMinutes.map { "\($0)m" } ?? "Open")
                                .frame(width: 48, alignment: .trailing)
                            Text(item.match)
                                .frame(width: 60, alignment: .trailing)
                        }
                        .font(.system(.body, design: .monospaced))
                        .padding(.vertical, 5)
                    }
                }
            }
        }
    }

    private var patternPrompt: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("A QUESTION FOR NEXT WEEK")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundStyle(Color.ledgerRed)
                Text(promptText)
                    .font(.system(.title3, design: .serif))
                    .italic()
            }
        }
    }

    private func miniMetric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.system(size: 10, design: .monospaced))
            Text(value).font(.system(.title2, design: .monospaced, weight: .semibold)).monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .overlay { Rectangle().stroke(Color.ink, lineWidth: 1) }
    }

    private var reasonSummaries: [ReasonSummary] {
        let grouped = Dictionary(grouping: recent, by: \.reason)
        return grouped.map { reason, sessions in
            let durations = sessions.compactMap { session -> Int? in
                guard let closedAt = session.closedAt else { return nil }
                return max(1, Int(closedAt.timeIntervalSince(session.enteredAt) / 60))
            }
            let average = durations.isEmpty ? nil : durations.reduce(0, +) / durations.count
            return ReasonSummary(
                reason: reason,
                count: sessions.count,
                averageMinutes: average,
                match: scoreText(sessions)
            )
        }
        .sorted { $0.count > $1.count }
    }

    private var recentDismissals: Int {
        let cutoff = Date().addingTimeInterval(-7 * 86_400)
        return model.state.dismissals.filter { $0.occurredAt >= cutoff }.count
    }

    private var promptText: String {
        guard let top = reasonSummaries.first else {
            return "Which app visit would be worth naming before it begins?"
        }
        return "\(top.reason) appeared most often. Did those visits do what you hoped?"
    }
}

private struct ReasonSummary: Identifiable {
    var id: String { reason }
    let reason: String
    let count: Int
    let averageMinutes: Int?
    let match: String
}

struct SettingsView: View {
    @ObservedObject var model: DialogueModel
    @State private var editingApps = false
    @State private var confirmingDelete = false

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        DialogueHeader(kicker: "On device", title: "Settings")
                        LedgerCard {
                            Toggle("Pause all gates", isOn: Binding(
                                get: { model.state.isPaused },
                                set: { model.setPaused($0) }
                            ))
                            .font(.system(.body, design: .monospaced))
                            Text(model.state.isPaused ? "All watched apps are open." : "Your watched apps are gated.")
                                .font(.system(.caption, design: .serif))
                                .foregroundStyle(Color.ink.opacity(0.65))
                        }
                        Button("Edit watched apps") { editingApps = true }
                            .buttonStyle(LedgerButtonStyle())
                        LedgerCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("PRIVACY")
                                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                                Text("Your watched apps, intentions, notes, and scores stay in the app group on this iPhone. dialogue has no account and sends no analytics.")
                                    .font(.system(.body, design: .serif))
                                Link("Read the privacy policy", destination: URL(string: "https://dialogue-five.vercel.app/privacy")!)
                                Link("Get support", destination: URL(string: "https://dialogue-five.vercel.app/support")!)
                            }
                        }
                        Button("Delete all dialogue data", role: .destructive) {
                            confirmingDelete = true
                        }
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 22)
                }
            }
            .navigationTitle("")
        }
        .sheet(isPresented: $editingApps) {
            WatchedAppsEditor(model: model, isOnboarding: false)
        }
        .confirmationDialog(
            "Delete every watched app and ledger entry?",
            isPresented: $confirmingDelete,
            titleVisibility: .visible
        ) {
            Button("Delete all data", role: .destructive) { model.deleteAllData() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

private func scoreText(_ sessions: [SessionRecord]) -> String {
    IMS.score(sessions: sessions).map(IMS.displayString) ?? "No data"
}

private func scoreColor(_ sessions: [SessionRecord]) -> Color {
    guard let score = IMS.score(sessions: sessions) else { return .ink }
    return score >= 0.7 ? .ledgerGreen : .ledgerRed
}

private func verdictLabel(_ verdict: Verdict) -> String {
    switch verdict {
    case .yes: return "YES"
    case .partly: return "PARTLY"
    case .no: return "NO"
    case .unlogged: return "OPEN"
    }
}

private func verdictColor(_ verdict: Verdict) -> Color {
    switch verdict {
    case .yes: return .ledgerGreen
    case .partly, .unlogged: return .ink
    case .no: return .ledgerRed
    }
}

private func durationText(_ session: SessionRecord) -> String {
    guard let closedAt = session.closedAt else { return "In progress" }
    let minutes = max(1, Int(closedAt.timeIntervalSince(session.enteredAt) / 60))
    let qualifier = session.closeSource == .rearm ? "" : "Approx. "
    return "\(qualifier)\(minutes) min"
}
