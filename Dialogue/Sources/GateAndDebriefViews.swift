import DialogueKit
import SwiftUI

struct IntentionGateView: View {
    @ObservedObject var model: DialogueModel
    let app: WatchedApp
    @Environment(\.dynamicTypeSize) private var textSize
    @State private var selectedReason: String?
    @State private var customReason = ""
    @State private var secondsRemaining: Int
    @FocusState private var writing: Bool

    init(model: DialogueModel, app: WatchedApp) {
        self.model = model
        self.app = app
        _secondsRemaining = State(initialValue: app.gateTier.settleSeconds)
    }

    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DialogueHeader(kicker: "Before · \(app.displayName)", title: "What brings\nyou here?")
                    if !app.reminderLine.isEmpty {
                        Text(app.reminderLine).font(.system(.title3, design: .serif)).lineSpacing(3)
                    }
                    HStack(spacing: 12) {
                        Image(systemName: secondsRemaining > 0 ? "hourglass" : "checkmark")
                            .accessibilityHidden(true)
                        Text(secondsRemaining > 0 ? "A \(secondsRemaining)-second pause, if you need it." : "Ready when you are.")
                            .font(.system(.caption, design: .monospaced))
                            .monospacedDigit()
                    }.foregroundStyle(Color.ledgerGreen)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionLabel(text: "Name your intention")
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: textSize.isAccessibilitySize ? 1 : 2), spacing: 10) {
                            ForEach(Array(Set(app.reasonChips)).sorted { a, b in
                                (app.reasonChips.firstIndex(of: a) ?? 0) < (app.reasonChips.firstIndex(of: b) ?? 0)
                            }, id: \.self) { reason in
                                Button {
                                    selectedReason = reason
                                    customReason = ""
                                    writing = false
                                } label: {
                                    Text(reason).font(.system(.body, design: .serif))
                                        .frame(maxWidth: .infinity, minHeight: 48).padding(.horizontal, 8)
                                        .foregroundStyle(selectedReason == reason ? Color.paper : Color.ink)
                                        .background(selectedReason == reason ? Color.ink : Color.clear)
                                        .overlay { Rectangle().stroke(Color.ink.opacity(0.6), lineWidth: 1) }
                                }
                                .accessibilityAddTraits(selectedReason == reason ? .isSelected : [])
                            }
                        }
                        TextField("Or write your own", text: $customReason, prompt: Text("Or write your own").foregroundStyle(Color.ink.opacity(0.65)), axis: .vertical)
                            .font(.system(.body, design: .serif)).lineLimit(1...3)
                            .padding(14).overlay { Rectangle().stroke(Color.ink.opacity(0.5), lineWidth: 1) }
                            .focused($writing).accessibilityIdentifier("customReason")
                            .onChange(of: customReason) { _, value in
                                if !value.isEmpty { selectedReason = nil }
                            }
                        Text("Bored counts. Rest counts. An honest answer is useful.")
                            .font(.system(.footnote, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                    }
                    VStack(spacing: 6) {
                        Button("Begin visit") { model.beginSession(reason: reason) }
                            .buttonStyle(LedgerButtonStyle()).accessibilityIdentifier("beginVisit")
                        Text("Then switch back to \(app.displayName).")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(Color.ink.opacity(0.7))
                        Button("Never mind") { model.dismissGate() }
                            .font(.system(.body, design: .serif)).foregroundStyle(Color.ink)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                }.padding(.vertical, 30)
            }.scrollDismissesKeyboard(.interactively)
        }
        .sensoryFeedback(.selection, trigger: selectedReason)
        .task {
            while secondsRemaining > 0 {
                do { try await Task.sleep(for: .seconds(1)) } catch { return }
                secondsRemaining -= 1
            }
        }
    }
    private var reason: String {
        let custom = customReason.trimmingCharacters(in: .whitespacesAndNewlines)
        return custom.isEmpty ? selectedReason ?? "Not specified" : custom
    }
}

struct DebriefView: View {
    @ObservedObject var model: DialogueModel
    let session: SessionRecord
    @State private var note = ""
    @State private var selected: Verdict?
    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        LedgerPage {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DialogueHeader(kicker: "After · \(model.appName(for: session))", title: "Was it what\nyou came for?")
                    LedgerCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionLabel(text: "Your intention")
                            Text(session.reason).font(.system(.title2, design: .serif))
                            Text(durationText(session)).font(.system(.caption, design: .monospaced))
                        }
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Did this visit match your intention?").font(.system(.body, design: .serif))
                        ViewThatFits(in: .horizontal) {
                            HStack(spacing: 10) { verdicts }
                            VStack(spacing: 10) { verdicts }
                        }
                        Text("No right answer. Unlogged visits never lower your score.")
                            .font(.system(.footnote, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                    }
                    TextField("Note (optional)", text: $note, prompt: Text("Note (optional)").foregroundStyle(Color.ink.opacity(0.65)), axis: .vertical)
                        .lineLimit(2...4).font(.system(.body, design: .serif))
                        .padding(14).overlay { Rectangle().stroke(Color.ink.opacity(0.45), lineWidth: 1) }
                        .accessibilityIdentifier("reflectionNote")
                    VStack(spacing: 4) {
                        Button("Log reflection") {
                            guard let selected else { return }
                            model.submitDebrief(verdict: selected, note: note)
                        }
                        .buttonStyle(LedgerButtonStyle()).disabled(selected == nil)
                        .accessibilityIdentifier("logReflection")
                        Button("Later, keep it in my ledger") { model.deferDebrief() }
                            .font(.system(.body, design: .serif)).frame(maxWidth: .infinity, minHeight: 48)
                    }
                }.padding(.vertical, 30)
            }.scrollDismissesKeyboard(.interactively)
        }
        .onAppear { note = session.note ?? ""; selected = session.verdict == .unlogged ? nil : session.verdict }
        .sensoryFeedback(.selection, trigger: selected)
    }
    @ViewBuilder private var verdicts: some View {
        verdictButton("Yes", verdict: .yes, symbol: "checkmark")
        verdictButton("Partly", verdict: .partly, symbol: "circle.lefthalf.filled")
        verdictButton("No", verdict: .no, symbol: "minus")
    }
    private func verdictButton(_ title: String, verdict: Verdict, symbol: String) -> some View {
        Button { selected = verdict } label: {
            VStack(spacing: 9) {
                Image(systemName: symbol).accessibilityHidden(true)
                Text(title).font(.system(.body, design: .monospaced, weight: .medium))
            }
            .frame(maxWidth: .infinity, minHeight: 65).padding(10)
            .foregroundStyle(selected == verdict ? Color.paper : Color.ink)
            .background(selected == verdict ? Color.ink : Color.clear)
            .overlay { Rectangle().stroke(Color.ink, lineWidth: 1) }
        }
        .accessibilityLabel(title).accessibilityAddTraits(selected == verdict ? .isSelected : [])
        .accessibilityIdentifier("verdict-\(verdict.rawValue)")
    }
}
