import SwiftUI
import FamilyControls
import ManagedSettings
import UserNotifications

struct ContentView: View {
    @State private var selection = FamilyActivitySelection()
    @State private var pickerPresented = false
    @State private var authorized = false
    @State private var shielded = false
    @State private var events: [LabEvent] = []

    private let store = ManagedSettingsStore()

    var body: some View {
        NavigationStack {
            List {
                Section("Setup") {
                    Button(authorized ? "Screen Time authorized" : "1. Request Screen Time authorization") {
                        Task {
                            do {
                                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                                authorized = true
                                LabLog.append(source: "app", name: "authorized")
                            } catch {
                                LabLog.append(source: "app", name: "authorization_error", detail: String(describing: error))
                            }
                            refresh()
                        }
                    }
                    Button("2. Grant notifications") {
                        Task {
                            let granted = (try? await UNUserNotificationCenter.current()
                                .requestAuthorization(options: [.alert, .sound])) ?? false
                            LabLog.append(source: "app", name: "notifications_granted", detail: String(granted))
                            refresh()
                        }
                    }
                    Button("3. Pick a victim app") { pickerPresented = true }
                        .familyActivityPicker(isPresented: $pickerPresented, selection: $selection)
                    Button("4. Start day monitoring") {
                        GraceController.shared.startThresholdMonitoring()
                        refresh()
                    }
                }

                Section("Shield") {
                    Toggle("Shield picked apps", isOn: $shielded)
                        .onChange(of: shielded) { _, on in
                            if on {
                                store.shield.applications = selection.applicationTokens
                                LabLog.append(source: "app", name: "shield_on",
                                              detail: "\(selection.applicationTokens.count) tokens")
                            } else {
                                store.shield.applications = nil
                                LabLog.append(source: "app", name: "shield_off")
                            }
                            refresh()
                        }
                    Button("Simulate grace window (clear + race re-arms)") {
                        GraceController.shared.begin(reason: "manual_test")
                        refresh()
                    }
                }

                Section("Timeline (\(events.count))") {
                    Button("Refresh") { refresh() }
                    ShareLink(item: LabLog.exportJSON()) {
                        Text("Export JSON")
                    }
                    Button("Clear", role: .destructive) {
                        LabLog.clear()
                        refresh()
                    }
                    ForEach(events.reversed()) { event in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(event.source): \(event.name)")
                                .font(.system(.footnote, design: .monospaced))
                            Text("\(event.at.formatted(date: .omitted, time: .standard))  \(event.detail)")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("dialogue lab")
            .onAppear {
                refresh()
                LabSelectionSync()
            }
            .onChange(of: selection) { _, newValue in
                LabSelection.save(newValue)
                LabLog.append(source: "app", name: "selection_saved",
                              detail: "\(newValue.applicationTokens.count) tokens")
                refresh()
            }
        }
    }

    private func refresh() {
        events = LabLog.load()
    }

    private func LabSelectionSync() {
        if let saved = LabSelection.load() {
            selection = saved
        }
    }
}
