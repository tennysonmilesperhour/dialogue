import DialogueKit
import SwiftUI

struct LedgerView: View {
    @ObservedObject var model: DialogueModel
    @State private var search = ""
    @State private var onlyPending = false

    private var entries: [SessionRecord] {
        model.state.sessions.filter { session in
            (!onlyPending || (session.closedAt != nil && session.verdict == .unlogged)) &&
            (search.isEmpty || [model.appName(for: session), session.reason, session.note ?? ""]
                .contains { $0.localizedCaseInsensitiveContains(search) })
        }.sorted { $0.enteredAt > $1.enteredAt }
    }
    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        DialogueHeader(kicker: "Your private record", title: "The ledger")
                        HStack {
                            Image(systemName: "magnifyingglass").accessibilityHidden(true)
                            TextField("Search apps, intentions, notes", text: $search)
                                .font(.system(.body, design: .serif)).accessibilityIdentifier("ledgerSearch")
                            if !search.isEmpty {
                                Button { search = "" } label: { Image(systemName: "xmark.circle.fill") }
                                    .frame(width: 44, height: 44).accessibilityLabel("Clear search")
                            }
                        }.padding(12).frame(minHeight: 48)
                            .overlay { Rectangle().stroke(Color.ink.opacity(0.35), lineWidth: 1) }
                        Picker("Entries", selection: $onlyPending) {
                            Text("All entries").tag(false)
                            Text("To reflect on").tag(true)
                        }.pickerStyle(.segmented)
                        if entries.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Image(systemName: "book.closed").font(.largeTitle).foregroundStyle(Color.ledgerRed).accessibilityHidden(true)
                                Text(search.isEmpty ? (onlyPending ? "All caught up." : "A fresh page.") : "No matching entries.")
                                    .font(.system(.title2, design: .serif))
                                Text(search.isEmpty ? (onlyPending ? "Your next visit will bring another chance to reflect." : "Begin a visit from Today. The intention you name will appear here.") : "Try a different app, intention, or word from a note.")
                                    .font(.system(.body, design: .serif))
                                if !onlyPending && search.isEmpty {
                                    Button("Begin a visit") { model.selectedTab = 0 }.buttonStyle(LedgerButtonStyle())
                                }
                            }.padding(.vertical, 24)
                        }
                        ForEach(entries) { session in
                            VStack(alignment: .leading, spacing: 12) {
                                ViewThatFits(in: .horizontal) {
                                    HStack(alignment: .firstTextBaseline) { appName(session); Spacer(); date(session) }
                                    VStack(alignment: .leading, spacing: 6) { appName(session); date(session) }
                                }
                                Text(session.reason).font(.system(.body, design: .serif))
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: session.verdict == .yes ? "checkmark" : session.verdict == .unlogged ? "circle.dotted" : "circle.lefthalf.filled")
                                        .accessibilityHidden(true)
                                    Text(session.closedAt == nil ? "In progress" : verdictLabel(session.verdict))
                                        .font(.system(.caption, design: .monospaced, weight: .semibold))
                                }.foregroundStyle(session.verdict == .yes ? Color.ledgerGreen : Color.ink)
                                Text(durationText(session)).font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.7))
                                if let note = session.note, !note.isEmpty {
                                    Text(note).font(.system(.body, design: .serif)).textSelection(.enabled)
                                        .padding(.leading, 12).overlay(alignment: .leading) { Rectangle().fill(Color.ledgerRed.opacity(0.5)).frame(width: 2) }
                                }
                                if session.closedAt != nil {
                                    Button(session.verdict == .unlogged ? "Reflect on this visit" : "Edit reflection") {
                                        model.openReflection(id: session.id)
                                    }.font(.system(.body, design: .serif)).frame(minHeight: 44)
                                        .accessibilityLabel("\(session.verdict == .unlogged ? "Reflect on" : "Edit reflection for") \(model.appName(for: session)), \(session.reason)")
                                }
                                Rule()
                            }.padding(.vertical, 5)
                        }
                    }.padding(.vertical, 24)
                }.scrollDismissesKeyboard(.interactively).refreshable { model.refreshFromSharedState() }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
    private func appName(_ session: SessionRecord) -> some View {
        Text(model.appName(for: session)).font(.system(.title3, design: .serif, weight: .semibold))
    }
    private func date(_ session: SessionRecord) -> some View {
        Text(session.enteredAt, format: .dateTime.month(.abbreviated).day().hour().minute())
            .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.75))
    }
}
