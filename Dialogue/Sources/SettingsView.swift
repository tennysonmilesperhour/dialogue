import DialogueKit
import SwiftUI
import UniformTypeIdentifiers

struct LedgerDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .commaSeparatedText] }
    var data: Data
    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws { data = configuration.file.regularFileContents ?? Data() }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: data) }
}

struct SettingsView: View {
    @ObservedObject var model: DialogueModel
    @StateObject private var notifications = NotificationSettings()
    @State private var editingApps = false
    @State private var confirmingDelete = false
    @State private var showingGuide = false
    @State private var exporting = false
    @State private var document = LedgerDocument(data: Data())
    @State private var exportType = UTType.json
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        DialogueHeader(kicker: "Make it yours", title: "Your settings")
                        LedgerCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle("Pause all gates", isOn: Binding(get: { model.state.isPaused }, set: { model.setPaused($0) }))
                                    .font(.system(.body, design: .serif))
                                Text(model.state.isPaused ? "Your apps are open. Resume whenever you want." : "The apps you chose will ask for an intention.")
                                    .font(.system(.footnote, design: .serif))
                            }
                        }
                        if !model.isSample {
                            Button("Edit watched apps") { editingApps = true }.buttonStyle(LedgerButtonStyle())
                            reminders
                        }
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(text: "Your words belong to you")
                            Text("Your ledger stays on this iPhone and in its device backups. No account, ads, or app analytics.")
                                .font(.system(.body, design: .serif))
                            Text("Keep a copy before deleting. Exports include your written entries, so share them only where you intend to.")
                                .font(.system(.footnote, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                            exportButton("Export as spreadsheet (CSV)", type: .commaSeparatedText)
                            exportButton("Export as JSON", type: .json)
                            Text("The ledger keeps your latest 1,000 visits and 1,000 walk-aways.")
                                .font(.system(.caption, design: .serif))
                        }
                        Rule()
                        VStack(alignment: .leading, spacing: 6) {
                            SectionLabel(text: "A little help")
                            Button("How dialogue works") { showingGuide = true }.frame(minHeight: 44)
                            Link("Email support", destination: URL(string: "mailto:morphiclabsdata@gmail.com")!).frame(minHeight: 44)
                            Link("Privacy policy", destination: URL(string: "https://dialogue-five.vercel.app/privacy")!).frame(minHeight: 44)
                            Link("Support guide", destination: URL(string: "https://dialogue-five.vercel.app/support")!).frame(minHeight: 44)
                            if !model.isSample { Button("Explore a sample ledger") { model.exploreSample() }.frame(minHeight: 44) }
                        }.font(.system(.body, design: .serif))
                        Rule()
                        if !model.isSample {
                            Button("Delete all dialogue data", role: .destructive) { confirmingDelete = true }
                                .font(.system(.body, design: .serif)).frame(minHeight: 48)
                            Text("Clears entries, app selections, gates, and reminders. Screen Time permission can be removed in iPhone Settings.")
                                .font(.system(.caption, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                        }
                        Text("dialogue · \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "3"))")
                            .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.6))
                    }.padding(.vertical, 24)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
        .task { if !model.isSample { await notifications.refresh() } }
        .onChange(of: scenePhase) { _, phase in if phase == .active && !model.isSample { Task { await notifications.refresh() } } }
        .sheet(isPresented: $editingApps) { WatchedAppsEditor(model: model, isOnboarding: false) }
        .sheet(isPresented: $showingGuide) { GuideView() }
        .fileExporter(isPresented: $exporting, document: document, contentType: exportType,
                      defaultFilename: "dialogue-ledger-\(Date().formatted(.iso8601.year().month().day().dateSeparator(.dash)))") { result in
            if case .failure = result { model.errorMessage = "Your export could not be saved. Your ledger is unchanged. Please try again." }
        }
        .confirmationDialog("Delete every watched app and ledger entry?", isPresented: $confirmingDelete, titleVisibility: .visible) {
            Button("Delete all data", role: .destructive) { model.deleteAllData() }
            Button("Keep my data", role: .cancel) {}
        } message: { Text("This cannot be undone. Export a copy first if you want to keep your entries.") }
    }
    private var reminders: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel(text: "Gentle reminders")
                Text("A private nudge after a visit. Your app names and intentions never appear on the lock screen.")
                    .font(.system(.body, design: .serif))
                if notifications.status == .notDetermined {
                    Button("Enable reflection reminders") { Task { await notifications.enableVisitReminders() } }.frame(minHeight: 44)
                } else if notifications.status == .denied {
                    Button("Open notification settings") {
                        openURL(URL(string: UIApplication.openNotificationSettingsURLString)!)
                    }.frame(minHeight: 44)
                } else {
                    Label("Reflection reminders allowed", systemImage: "checkmark.circle").font(.system(.footnote, design: .serif))
                }
                Toggle("Weekly review reminder", isOn: Binding(get: { notifications.weeklyEnabled }, set: { enabled in Task { await notifications.setWeekly(enabled) } }))
                    .font(.system(.body, design: .serif))
                Text("Sundays at 6 pm, in your local time. Always optional.").font(.system(.caption, design: .serif))
                if let message = notifications.message { Text(message).font(.system(.footnote, design: .serif)) }
            }
        }
    }
    private func exportButton(_ title: String, type: UTType) -> some View {
        Button {
            do {
                document = LedgerDocument(data: type == .json ? try LedgerExport.json(model.state) : Data(LedgerExport.csv(model.state).utf8))
                exportType = type
                exporting = true
            } catch { model.errorMessage = "The export could not be prepared. Please try again." }
        } label: { Label(title, systemImage: "square.and.arrow.up").font(.system(.body, design: .serif)).frame(minHeight: 44) }
    }
}

struct GuideView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        DialogueHeader(kicker: "The field guide", title: "A conversation\nwith yourself.")
                        section("Before a visit", "Open a watched app or begin from Today. Name why you are there, then switch back to that app. A suggested pause is optional, and Begin visit always works, even without a reason.")
                        section("After a visit", "End the visit in Today, or wait for your Screen Time reminder. Choose Yes, Partly, or No, then Log reflection. Later keeps it in your ledger. You can edit an answer at any time.")
                        section("Your intention match", "Over the last 14 days, Yes counts as one and Partly as half. No counts as zero. The total is divided by the number of reflections. Unlogged visits are excluded, never treated as failures.")
                        section("A lighter pause over time", "After 12 reflections for an app, its suggested pause follows your match rate: no pause at 85% or above, three seconds at 60–84%, and eight seconds below 60%. It changes at most once every 72 hours. You can always continue immediately.")
                        section("A note about timing", "iOS does not tell dialogue exactly when another app closes. Visit lengths include time away from the app and are approximate. Screen Time callbacks can arrive late. End a visit yourself for a more useful record.")
                        section("If a gate does not open dialogue", "On older iOS versions, tap the notification or open dialogue yourself. Your intention screen will be waiting. If needed, pause all gates in Settings or remove dialogue's Screen Time access in iPhone Settings.")
                        section("Private by design", "Your app choices, intentions, and notes stay on your device. Export only when you choose. Delete all data clears the ledger, gates, and reminders.")
                        Button("Got it") { dismiss() }.buttonStyle(LedgerButtonStyle())
                    }.padding(.vertical, 24)
                }
            }.toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
    private func section(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.system(.title3, design: .serif, weight: .semibold)).accessibilityAddTraits(.isHeader)
            Text(detail).font(.system(.body, design: .serif)).lineSpacing(4)
        }
    }
}
