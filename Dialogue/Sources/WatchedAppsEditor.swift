import DialogueKit
import FamilyControls
import ManagedSettings
import SwiftUI

struct WatchedAppsEditor: View {
    @ObservedObject var model: DialogueModel
    let isOnboarding: Bool
    var onCancel: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var apps: [WatchedApp]
    @State private var selection: FamilyActivitySelection
    @State private var pickerIsPresented = false
    @State private var selectionNote: String?

    init(model: DialogueModel, isOnboarding: Bool, onCancel: (() -> Void)? = nil) {
        self.model = model
        self.isOnboarding = isOnboarding
        self.onCancel = onCancel
        let existing = model.state.watchedApps
        _apps = State(initialValue: existing)
        var initialSelection = FamilyActivitySelection()
        initialSelection.applicationTokens = Set(existing.compactMap {
            ScreenTimeTokenCodec.decode($0.applicationTokenData)
        })
        _selection = State(initialValue: initialSelection)
    }

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        DialogueHeader(
                            kicker: isOnboarding ? "A small pause" : "Watched apps",
                            title: isOnboarding ? "Did you mean to open that?" : "Edit your gates"
                        )

                        if isOnboarding {
                            intro
                        }

                        if isOnboarding || !model.hasScreenTimeAuthorization { permission }

                        if model.hasScreenTimeAuthorization { selectionSection }

                        if !apps.isEmpty {
                            configurationSection
                        }

                        if let selectionNote {
                            Text(selectionNote)
                                .font(.system(.footnote, design: .monospaced))
                                .foregroundStyle(Color.ledgerRed)
                        }

                        Button(isOnboarding ? "Start my ledger" : "Save watched apps") {
                            save()
                        }
                        .buttonStyle(LedgerButtonStyle())
                        .disabled(!canSave)
                        .opacity(canSave ? 1 : 0.45)

                        Text("Your app choices and ledger stay on this iPhone.")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(Color.ink.opacity(0.65))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(isOnboarding ? "" : "Watched apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isOnboarding {
                    ToolbarItem(placement: .cancellationAction) { Button("Back") { onCancel?() } }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
        }
        .familyActivityPicker(
            headerText: "Choose individual apps",
            footerText: "dialogue places a reflective gate in front of each selected app.",
            isPresented: $pickerIsPresented,
            selection: $selection
        )
        .onChange(of: selection) { _, newValue in
            syncApps(to: newValue)
        }
    }

    private var intro: some View {
        Text("Name why you are opening an app. Reflect when the visit ends. Over time, see which intentions held up. Start with one app; you can change your choices or pause every gate in Settings.")
            .font(.system(.body, design: .serif))
            .foregroundStyle(Color.ink)
    }

    private var permission: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("1  ALLOW SCREEN TIME")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                Text(permissionCopy)
                    .font(.system(.body, design: .serif))
                if !model.hasScreenTimeAuthorization {
                    Button("Allow Screen Time access") {
                        Task { await model.requestAuthorization() }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var selectionSection: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(isOnboarding ? "2  CHOOSE APPS" : "CHOOSE APPS")
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                Text("Start with one app you often open without thinking. You can add more later. Choose individual apps rather than categories.")
                    .font(.system(.body, design: .serif))
                Button(apps.isEmpty ? "Choose apps" : "Change selection") {
                    pickerIsPresented = true
                }
                .buttonStyle(.bordered)
                .disabled(!model.hasScreenTimeAuthorization)
            }
        }
    }

    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isOnboarding ? "3  NAME THE INTENTION" : "APP DETAILS")
                .font(.system(.caption, design: .monospaced, weight: .semibold))
            ForEach($apps) { $app in
                LedgerCard {
                    VStack(alignment: .leading, spacing: 12) {
                        if let token = ScreenTimeTokenCodec.decode(app.applicationTokenData) {
                            Label(token)
                                .font(.system(.headline, design: .serif))
                        }
                        TextField("App name", text: $app.displayName)
                            .accessibilityLabel("Name for this app")
                            .textInputAutocapitalization(.words)
                            .textFieldStyle(.roundedBorder)
                        TextField("Reminder, such as: Message one person", text: $app.reminderLine)
                            .accessibilityLabel("Personal reminder, optional")
                            .textFieldStyle(.roundedBorder)
                        Text("A reminder to reflect after about this much app use. iOS may deliver it later.")
                            .font(.system(.caption, design: .serif))
                        Picker("Reflect after", selection: $app.softBudgetSeconds) {
                            Text("5 minutes").tag(5 * 60)
                            Text("10 minutes").tag(10 * 60)
                            Text("15 minutes").tag(15 * 60)
                            Text("30 minutes").tag(30 * 60)
                        }
                        .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
    }

    private var permissionCopy: String {
        switch model.authorizationStatus {
        case .approved: return "Approved. dialogue can place and remove the gates you choose."
        case .approvedWithDataAccess: return "Approved. dialogue can place and remove the gates you choose."
        case .denied: return "Denied. Enable Screen Time access in Settings to use app gates."
        case .notDetermined: return "Required to show a gate over the apps you select."
        @unknown default: return "Screen Time authorization is unavailable."
        }
    }

    private var canSave: Bool {
        model.hasScreenTimeAuthorization &&
        (!isOnboarding || !apps.isEmpty) &&
        apps.allSatisfy { !$0.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    private func syncApps(to newSelection: FamilyActivitySelection) {
        let selectedData = Set(newSelection.applicationTokens.compactMap(ScreenTimeTokenCodec.encode))
        apps.removeAll { app in
            guard let data = app.applicationTokenData else { return true }
            return !selectedData.contains(data)
        }
        let existingData = Set(apps.compactMap(\.applicationTokenData))
        for token in newSelection.applicationTokens {
            guard let data = ScreenTimeTokenCodec.encode(token), !existingData.contains(data) else { continue }
            apps.append(WatchedApp(displayName: "", applicationTokenData: data))
        }
        selectionNote = newSelection.categoryTokens.isEmpty && newSelection.webDomainTokens.isEmpty
            ? nil
            : "Only individual apps were added. Categories and websites were ignored."
    }

    private func save() {
        var cleaned = apps
        for index in cleaned.indices {
            cleaned[index].displayName = String(cleaned[index].displayName.trimmingCharacters(in: .whitespacesAndNewlines).prefix(50))
            cleaned[index].reminderLine = String(cleaned[index].reminderLine.trimmingCharacters(in: .whitespacesAndNewlines).prefix(160))
        }
        if isOnboarding {
            model.finishOnboarding(with: cleaned)
        } else {
            if model.replaceWatchedApps(cleaned) { dismiss() }
        }
    }
}
