import DialogueKit
import SwiftUI

struct HomeView: View {
    @StateObject private var model = DialogueModel()
    @ObservedObject private var route = NotificationRoute.shared
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var settingUp = false

    var body: some View {
        VStack(spacing: 0) {
            if model.isSample {
                HStack {
                    Label("Sample ledger", systemImage: "eye")
                    Spacer()
                    Button("Exit sample") { model.exitSample() }
                        .accessibilityIdentifier("exitSample")
                }
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .padding(.horizontal, 20)
                .frame(minHeight: 44)
                // Keep the status-bar region dark in both appearances.
                .background(Color(token: DesignTokens.ColorHex.ink))
                .foregroundStyle(Color(token: DesignTokens.ColorHex.paper))
            }
            Group {
                if model.state.onboardingCompleted {
                    MainTabs(model: model)
                } else if settingUp {
                    WatchedAppsEditor(model: model, isOnboarding: true, onCancel: { settingUp = false })
                } else {
                    WelcomeView(start: { settingUp = true }, sample: { model.exploreSample() })
                }
            }
        }
        .background(Color.paper)
        .foregroundStyle(Color.ink)
        .tint(Color.ledgerRed)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.state.onboardingCompleted)
        .sheet(isPresented: Binding(
            get: { model.gateAppID != nil || model.debriefSessionID != nil || model.offerReminders },
            set: { if !$0 { model.gateAppID = nil; model.deferDebrief(); model.offerReminders = false } }
        )) {
            if let app = model.gateApp {
                IntentionGateView(model: model, app: app).interactiveDismissDisabled()
            } else if let session = model.debriefSession {
                DebriefView(model: model, session: session)
            } else if model.offerReminders {
                ReminderInvitation(model: model)
            }
        }
        .alert("A note from dialogue", isPresented: Binding(
            get: { model.errorMessage != nil }, set: { if !$0 { model.errorMessage = nil } }
        )) {
            Button("OK") { model.errorMessage = nil }
        } message: { Text(model.errorMessage ?? "") }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.refreshFromSharedState(); handleNotification() }
        }
        .onReceive(route.$pending) { _ in
            // Schedule after the published value is assigned.
            Task { @MainActor in handleNotification() }
        }
        .onOpenURL { url in
            guard url.scheme == "dialogue" else { return }
            model.refreshFromSharedState()
        }
        .task { handleNotification() }
    }

    private func handleNotification() {
        guard let (destination, sessionID) = route.pending, !model.isSample else { return }
        route.pending = nil
        model.refreshFromSharedState()
        if destination == "review" {
            model.deferDebrief()
            model.selectedTab = 2
        } else if destination == "gate" {
            // refreshFromSharedState consumed the pending gate handoff.
        } else if let sessionID, let id = UUID(uuidString: sessionID) {
            model.openReflection(id: id)
        }
    }
}

struct LedgerPage<Content: View>: View {
    @ViewBuilder let content: Content
    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.paper.ignoresSafeArea()
            Rectangle().fill(Color.ledgerRed.opacity(0.55)).frame(width: 1)
                .padding(.leading, textSize.isAccessibilitySize ? 12 : 23).ignoresSafeArea()
                .accessibilityHidden(true)
            content
                .padding(.leading, textSize.isAccessibilitySize ? 24 : 38)
                .padding(.trailing, 22)
        }
        .foregroundStyle(Color.ink)
    }
}

struct LedgerCard<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        content.frame(maxWidth: .infinity, alignment: .leading).padding(18)
            .background(Color.paper)
            .background { Rectangle().fill(Color.ink.opacity(0.85)).offset(x: 3, y: 3) }
            .overlay { Rectangle().stroke(Color.ink, lineWidth: 1) }
    }
}

struct DialogueHeader: View {
    let kicker: String
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel(text: kicker)
            Text(title).font(.system(.largeTitle, design: .serif, weight: .medium))
                .fixedSize(horizontal: false, vertical: true).accessibilityAddTraits(.isHeader)
            Rule().padding(.top, 6)
        }
    }
}

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text.uppercased()).font(.system(.caption, design: .monospaced, weight: .semibold))
            .tracking(1.6).foregroundStyle(Color.ledgerRed).accessibilityAddTraits(.isHeader)
    }
}

struct Rule: View {
    var body: some View {
        Rectangle().fill(Color.ink.opacity(0.3)).frame(height: 1).accessibilityHidden(true)
    }
}

struct LedgerButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .monospaced, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 24).padding(.vertical, 15).padding(.horizontal, 12)
            .foregroundStyle(Color.paper)
            .background(Color.ink.opacity(isEnabled ? 1 : 0.38))
            .offset(y: configuration.isPressed && !reduceMotion ? 2 : 0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct WelcomeView: View {
    let start: () -> Void
    let sample: () -> Void
    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    HStack {
                        Text("dialogue").font(.system(.title2, design: .serif, weight: .semibold))
                        Spacer()
                        Image(systemName: "book.closed").font(.title3).accessibilityHidden(true)
                    }
                    .padding(.top, 18)
                    Rule()
                    VStack(alignment: .leading, spacing: 18) {
                        SectionLabel(text: "A little more on purpose")
                        Text("Did you mean\nto open that?")
                            .font(.system(.largeTitle, design: .serif, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.isHeader)
                        Text("Name the intention. Notice what happened. Keep a private record of the difference.")
                            .font(.system(.title3, design: .serif)).lineSpacing(4)
                    }
                    LedgerCard {
                        VStack(alignment: .leading, spacing: 18) {
                            welcomeRow("01", "Before", "What brings you here?")
                            Rule()
                            welcomeRow("02", "After", "Was it what you came for?")
                            Rule()
                            welcomeRow("03", "Over time", "See which intentions hold up.")
                        }
                    }
                    VStack(spacing: 8) {
                        Button("Set up my first app", action: start).buttonStyle(LedgerButtonStyle())
                            .accessibilityIdentifier("beginSetup")
                        Button("Explore a sample ledger", action: sample)
                            .font(.system(.body, design: .serif)).frame(minHeight: 48)
                            .accessibilityIdentifier("exploreSample")
                        Text("Free. Private. No account needed.")
                            .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.7))
                    }
                }.padding(.vertical, 20)
            }
        }
    }
    private func welcomeRow(_ number: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text(number).font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ledgerRed).padding(.top, 3)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(.headline, design: .serif))
                Text(detail).font(.system(.body, design: .serif))
            }
        }.accessibilityElement(children: .combine)
    }
}
