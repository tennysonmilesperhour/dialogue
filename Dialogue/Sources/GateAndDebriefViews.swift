import DialogueKit
import SwiftUI

struct IntentionGateView: View {
    @ObservedObject var model: DialogueModel
    let app: WatchedApp

    @State private var selectedReason: String?
    @State private var typedWord = ""
    @State private var secondsRemaining: Int

    init(model: DialogueModel, app: WatchedApp) {
        self.model = model
        self.app = app
        _secondsRemaining = State(initialValue: app.gateTier.settleSeconds)
    }

    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    DialogueHeader(kicker: app.displayName, title: "Why are you here?")

                    if !app.reminderLine.isEmpty {
                        Text(app.reminderLine)
                            .font(.system(.title3, design: .serif))
                            .italic()
                            .foregroundStyle(Color.ledgerRed)
                    }

                    Text("Choose the reason that is true right now.")
                        .font(.system(.body, design: .serif))

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(app.reasonChips, id: \.self) { reason in
                            Button(reason) { selectedReason = reason }
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, minHeight: 46)
                                .foregroundStyle(selectedReason == reason ? Color.paper : Color.ink)
                                .background(selectedReason == reason ? Color.ink : Color.clear)
                                .overlay { Rectangle().stroke(Color.ink, lineWidth: 1) }
                        }
                    }

                    if app.gateTier.requiresTypedWord {
                        TextField("Type one word for what you want", text: $typedWord)
                            .textFieldStyle(.roundedBorder)
                    }

                    Button(buttonTitle) {
                        guard let selectedReason else { return }
                        model.beginSession(reason: selectedReason)
                    }
                    .buttonStyle(LedgerButtonStyle())
                    .disabled(!canEnter)
                    .opacity(canEnter ? 1 : 0.45)

                    Button("Never mind") {
                        model.gateAppID = nil
                    }
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 28)
            }
        }
        .task {
            while secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                secondsRemaining -= 1
            }
        }
    }

    private var canEnter: Bool {
        selectedReason != nil &&
        secondsRemaining == 0 &&
        (!app.gateTier.requiresTypedWord || !typedWord.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    private var buttonTitle: String {
        secondsRemaining > 0 ? "Settle for \(secondsRemaining)" : "Enter \(app.displayName)"
    }
}

struct DebriefView: View {
    @ObservedObject var model: DialogueModel
    let session: SessionRecord
    @State private var note = ""

    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    DialogueHeader(
                        kicker: model.appName(for: session),
                        title: "Did that match your intention?"
                    )
                    Text("You opened it to: \(session.reason)")
                        .font(.system(.title3, design: .serif))

                    VStack(spacing: 10) {
                        verdictButton("Yes", verdict: .yes, color: .ledgerGreen)
                        verdictButton("Partly", verdict: .partly, color: .ink)
                        verdictButton("No", verdict: .no, color: .ledgerRed)
                    }

                    TextField("Optional note", text: $note, axis: .vertical)
                        .lineLimit(2...5)
                        .textFieldStyle(.roundedBorder)

                    Button("Later") { model.deferDebrief() }
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(Color.ink)
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 28)
            }
        }
    }

    private func verdictButton(_ title: String, verdict: Verdict, color: Color) -> some View {
        Button(title) {
            model.submitDebrief(verdict: verdict, note: note)
        }
        .font(.system(.title3, design: .monospaced, weight: .semibold))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .foregroundStyle(color)
        .overlay { Rectangle().stroke(color, lineWidth: 1.5) }
    }
}
