import DialogueKit
import SwiftUI

struct MainTabs: View {
    @ObservedObject var model: DialogueModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TabView(selection: $model.selectedTab) {
            TodayView(model: model).tabItem { Label("Today", systemImage: "book.closed") }.tag(0)
            LedgerView(model: model).tabItem { Label("Ledger", systemImage: "list.bullet.rectangle") }.tag(1)
            WeeklyReviewView(model: model).tabItem { Label("Review", systemImage: "chart.bar.xaxis") }.tag(2)
            SettingsView(model: model).tabItem { Label("Settings", systemImage: "slider.horizontal.3") }.tag(3)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            if let message = model.lastLoggedMessage {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill").foregroundStyle(Color.ledgerGreen)
                        .rotationEffect(.degrees(reduceMotion ? 0 : -8)).accessibilityHidden(true)
                    Text(message).font(.system(.subheadline, design: .serif))
                    Spacer(minLength: 0)
                    Button("Undo") { model.undoLastReflection() }.frame(minHeight: 44)
                    Button { model.lastLoggedMessage = nil } label: { Image(systemName: "xmark") }
                        .frame(width: 44, height: 44).accessibilityLabel("Dismiss confirmation")
                }
                .padding(.leading, 20).background(Color.paper)
                .overlay(alignment: .bottom) { Rule() }
                .transition(.opacity)
                .accessibilityIdentifier("loggedConfirmation")
            }
        }
        .sensoryFeedback(.success, trigger: model.lastLoggedMessage)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: model.lastLoggedMessage)
    }
}

struct TodayView: View {
    @ObservedObject var model: DialogueModel
    @State private var showingGuide = false
    @State private var editingApps = false
    @ScaledMetric(relativeTo: .largeTitle) private var scoreSize = 72

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("dialogue").font(.system(.title2, design: .serif, weight: .semibold))
                            Spacer()
                            Text(Date(), format: .dateTime.month(.abbreviated).day())
                                .font(.system(.caption, design: .monospaced)).textCase(.uppercase)
                        }
                        Rule()
                        if model.state.isPaused {
                            LedgerCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Label("Gates are paused", systemImage: "pause.circle")
                                    Text("Your apps are open. Your ledger stays here.").font(.system(.body, design: .serif))
                                    Button("Resume gates") { model.setPaused(false) }.frame(minHeight: 44)
                                }
                            }
                        }
                        if !model.hasScreenTimeAuthorization && !model.isSample { permissionCard }
                        if let active = model.activeSession { activeSessionCard(active) }
                        if let pending = model.state.pendingDebriefs.first { pendingCard(pending) }
                        scoreCard
                        startCard
                        if !model.state.watchedApps.isEmpty { perAppScores }
                        Button { showingGuide = true } label: {
                            Label("How dialogue works", systemImage: "questionmark.circle")
                                .font(.system(.body, design: .serif)).frame(minHeight: 48)
                        }
                    }.padding(.vertical, 22)
                }.refreshable { model.refreshFromSharedState() }
            }.toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showingGuide) { GuideView() }
        .sheet(isPresented: $editingApps) { WatchedAppsEditor(model: model, isOnboarding: false) }
    }

    private var scoreCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: "Your intention match")
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(IMS.score(sessions: model.state.sessions).map { String(Int(($0 * 100).rounded())) } ?? "—") // copy-lint: allow
                    .font(.system(size: scoreSize, weight: .regular, design: .serif)).monospacedDigit()
                    .contentTransition(.numericText())
                if IMS.score(sessions: model.state.sessions) != nil {
                    Text("%").font(.system(.title, design: .serif)).foregroundStyle(Color.ledgerGreen)
                }
            }.accessibilityElement(children: .ignore)
                .accessibilityLabel("Intention match, \(scoreText(model.state.sessions))")
            Text("14 DAYS · \(IMS.loggedCount(sessions: model.state.sessions)) REFLECTIONS")
                .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.75))
            Text(IMS.loggedCount(sessions: model.state.sessions) == 0
                 ? "Your first reflection starts the picture. One visit is enough to begin."
                 : "A record of what held up, with room for what did not.")
                .font(.system(.title3, design: .serif)).lineSpacing(3)
            Button("What goes into this number?") { showingGuide = true }
                .font(.system(.footnote, design: .serif)).frame(minHeight: 44)
            Rule()
        }
    }
    private var permissionCard: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel(text: "Reconnect your gates")
                Text("Screen Time access is off. Your saved entries are still here.").font(.system(.body, design: .serif))
                Button("Allow Screen Time") { Task { await model.requestAuthorization() } }.frame(minHeight: 44)
            }
        }
    }
    private func activeSessionCard(_ session: SessionRecord) -> some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("VISIT IN PROGRESS", systemImage: "circle.inset.filled")
                    .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ledgerGreen)
                Text(model.appName(for: session)).font(.system(.title2, design: .serif))
                Text(session.reason).font(.system(.body, design: .serif))
                Text("Switch back to the app. Reflect here when you finish, or when your reminder arrives.")
                    .font(.system(.footnote, design: .serif))
                Text(session.enteredAt, style: .timer).font(.system(.title3, design: .monospaced))
                    .accessibilityLabel("Elapsed time since this visit began")
                Button("End visit and reflect") { model.endActiveSession() }
                    .buttonStyle(LedgerButtonStyle()).accessibilityIdentifier("endVisit")
            }
        }
    }
    private func pendingCard(_ session: SessionRecord) -> some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel(text: "A moment to look back")
                Text("You came to \(session.reason.lowercased()). How did it go?")
                    .font(.system(.title3, design: .serif))
                HStack {
                    Text(model.appName(for: session)).font(.system(.caption, design: .monospaced))
                    Spacer()
                    Text("\(model.state.pendingDebriefs.count) to reflect on").font(.system(.caption, design: .serif))
                }
                Button("Reflect on this visit") { model.openReflection(id: session.id) }
                    .buttonStyle(LedgerButtonStyle()).accessibilityIdentifier("reflectNow")
            }
        }
    }
    private var startCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionLabel(text: "Begin on purpose")
            if model.state.watchedApps.isEmpty {
                Text("Choose an app for your next visit. Your previous entries stay in the ledger.")
                    .font(.system(.body, design: .serif))
                Button("Choose an app") { editingApps = true }.buttonStyle(LedgerButtonStyle())
            } else {
                ForEach(model.state.watchedApps) { app in
                    Button { model.gateAppID = app.id } label: {
                        HStack(spacing: 12) {
                            Text(String(app.displayName.prefix(1)).uppercased())
                                .font(.system(.title3, design: .serif)).frame(width: 42, height: 42)
                                .overlay { Rectangle().stroke(Color.ink.opacity(0.4), lineWidth: 1) }.accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.displayName).font(.system(.title3, design: .serif))
                                Text("\(app.softBudgetSeconds / 60) min reminder")
                                    .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.7))
                            }
                            Spacer(minLength: 4)
                            Image(systemName: "arrow.up.right").accessibilityHidden(true)
                        }.padding(.vertical, 8).contentShape(Rectangle())
                    }.foregroundStyle(Color.ink).accessibilityLabel("Begin visit to \(app.displayName)")
                    Rule()
                }
            }
        }
    }
    private var perAppScores: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: "The last fourteen days")
            ForEach(model.state.watchedApps) { app in
                let entries = model.state.sessions.filter { $0.appID == app.id }
                HStack(alignment: .firstTextBaseline) {
                    Text(app.displayName).font(.system(.body, design: .serif))
                    Spacer()
                    Text(scoreText(entries)).font(.system(.body, design: .monospaced)).monospacedDigit()
                }.accessibilityElement(children: .combine)
            }
        }
    }
}

func scoreText(_ sessions: [SessionRecord]) -> String {
    IMS.score(sessions: sessions).map(IMS.displayString) ?? "Not yet"
}
func verdictLabel(_ verdict: Verdict) -> String {
    switch verdict { case .yes: return "Matched"; case .partly: return "Partly"; case .no: return "Did not match"; case .unlogged: return "To reflect on" }
}
func durationText(_ session: SessionRecord) -> String {
    guard let end = session.closedAt else { return "In progress" }
    return "About \(max(1, Int(end.timeIntervalSince(session.enteredAt) / 60))) min elapsed"
}
