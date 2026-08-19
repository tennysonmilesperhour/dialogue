import DialogueKit
import FamilyControls
import SwiftUI

/// Phase 0 smoke test, not the product.
///
/// The phase 0 gate is "the workspace installs on a device", so this page
/// answers the three questions that gate actually turns on: does DialogueKit
/// link and render the ledger tokens, is the app group wired in every
/// target's entitlements, and is the Family Controls entitlement live on
/// this build. The real Home, the gate, and the debrief land in phase 2,
/// after the week 1 prototype settles D012 (docs/PLAN.md).
struct HomeView: View {
    @State private var authorization: AuthorizationStatus?
    @State private var appGroupNote = "Checking"
    @State private var requestFailure: String?

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.paper.ignoresSafeArea()

            Rectangle()
                .fill(Color.ledgerRed)
                .frame(width: 1)
                .padding(.leading, DesignTokens.Layout.marginRuleX)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                header
                checks
                if let requestFailure {
                    Text(requestFailure)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(Color.ledgerRed)
                }
                Spacer()
                footer
            }
            .padding(.leading, DesignTokens.Layout.marginRuleX + 18)
            .padding(.trailing, 20)
            .padding(.vertical, 28)
        }
        .task {
            authorization = AuthorizationCenter.shared.authorizationStatus
            appGroupNote = Self.appGroupCheck()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("dialogue")
                .font(.system(.largeTitle, design: .serif))
                .foregroundStyle(Color.ink)
            Text("Did you mean to open that?")
                .font(.system(.body, design: .serif))
                .italic()
                .foregroundStyle(Color.ledgerRed)
            Rectangle()
                .fill(Color.ink)
                .frame(height: DesignTokens.Layout.borderWidth)
                .padding(.top, 8)
        }
    }

    private var checks: some View {
        VStack(alignment: .leading, spacing: 14) {
            row("Screen Time access", authorizationNote)
            row("App group", appGroupNote)
            row("DialogueKit", "Linked, \(IMS.windowDays) day window")

            if authorization != .approved {
                Button("Request Screen Time access") {
                    Task { await requestAuthorization() }
                }
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.paper)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.ink)
            }
        }
    }

    private var footer: some View {
        Text("Phase 0 scaffold. The gate and the debrief arrive in phase 2.")
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(Color.ink.opacity(0.6))
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.ink)
            Spacer(minLength: 12)
            Text(value)
                .font(.system(.body, design: .monospaced))
                .monospacedDigit()
                .multilineTextAlignment(.trailing)
                .foregroundStyle(Color.ink)
        }
        .padding(.bottom, 6)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.ink.opacity(0.25))
                .frame(height: 1)
        }
    }

    private var authorizationNote: String {
        guard let authorization else { return "Checking" }
        switch authorization {
        case .approved: return "Approved"
        case .denied: return "Denied"
        case .notDetermined: return "Not requested"
        @unknown default: return "Unknown"
        }
    }

    @MainActor
    private func requestAuthorization() async {
        requestFailure = nil
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        } catch {
            requestFailure = "Authorization request failed: \(error.localizedDescription)"
        }
        authorization = AuthorizationCenter.shared.authorizationStatus
    }

    /// Writes and reads back one marker so a missing app group shows up here
    /// rather than as an extension that silently does nothing in phase 2.
    private static func appGroupCheck() -> String {
        guard let defaults = AppGroup.sharedDefaults else {
            return "Missing from entitlements"
        }
        let key = "scaffold.check"
        let stamp = Date().timeIntervalSince1970
        defaults.set(stamp, forKey: key)
        guard defaults.double(forKey: key) == stamp else {
            return "Not writable"
        }
        return "Readable and writable"
    }
}

#Preview {
    HomeView()
}
