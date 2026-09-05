import DialogueKit
import SwiftUI

struct HomeView: View {
    @StateObject private var model = DialogueModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if model.state.onboardingCompleted {
                MainTabs(model: model)
            } else {
                WatchedAppsEditor(model: model, isOnboarding: true)
            }
        }
        .preferredColorScheme(.light)
        .tint(Color.ledgerRed)
        .sheet(
            isPresented: Binding(
                get: { model.gateAppID != nil },
                set: { if !$0 { model.gateAppID = nil } }
            )
        ) {
            if let app = model.gateApp {
                IntentionGateView(model: model, app: app)
                    .interactiveDismissDisabled()
            }
        }
        .sheet(
            isPresented: Binding(
                get: { model.debriefSessionID != nil },
                set: { if !$0 { model.deferDebrief() } }
            )
        ) {
            if let session = model.debriefSession {
                DebriefView(model: model, session: session)
            }
        }
        .alert(
            "dialogue needs attention",
            isPresented: Binding(
                get: { model.errorMessage != nil },
                set: { if !$0 { model.errorMessage = nil } }
            )
        ) {
            Button("OK") { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                model.refreshFromSharedState()
            }
        }
        .onOpenURL { _ in
            model.refreshFromSharedState()
        }
    }
}

struct LedgerPage<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.paper.ignoresSafeArea()
            Rectangle()
                .fill(Color.ledgerRed)
                .frame(width: 1)
                .padding(.leading, DesignTokens.Layout.marginRuleX)
                .ignoresSafeArea()
            content
                .padding(.leading, DesignTokens.Layout.marginRuleX + 16)
                .padding(.trailing, 16)
        }
    }
}

struct LedgerCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.paper)
            .overlay {
                Rectangle().stroke(Color.ink, lineWidth: DesignTokens.Layout.borderWidth)
            }
    }
}

struct DialogueHeader: View {
    let kicker: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(kicker.uppercased())
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(Color.ledgerRed)
            Text(title)
                .font(.system(.largeTitle, design: .serif, weight: .semibold))
                .foregroundStyle(Color.ink)
            Rectangle()
                .fill(Color.ink)
                .frame(height: DesignTokens.Layout.borderWidth)
                .padding(.top, 5)
        }
    }
}

#Preview {
    HomeView()
}
