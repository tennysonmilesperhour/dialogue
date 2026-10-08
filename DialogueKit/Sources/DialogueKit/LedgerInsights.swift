import Foundation

/// Calendar-based summaries exclude future records and never grade missing reflections.
public struct LedgerInsights: Sendable {
    public let sessions: [SessionRecord]
    public let days: [Day]
    public let reasons: [Reason]
    public let reflectionCount: Int
    public let match: Double?
    public let previousMatch: Double?

    public struct Day: Identifiable, Sendable {
        public var id: Date { date }
        public let date: Date
        public let visits: Int
        public let reflections: Int
        public let match: Double?
    }
    public struct Reason: Identifiable, Sendable {
        public var id: String { name }
        public let name: String
        public let visits: Int
        public let averageMinutes: Int?
        public let match: Double?
    }

    public init(state: DialogueState, now: Date = Date(), calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: now)
        let start = calendar.date(byAdding: .day, value: -6, to: today)!
        let previousStart = calendar.date(byAdding: .day, value: -7, to: start)!
        let recent = state.sessions.filter { $0.enteredAt >= start && $0.enteredAt <= now }
        sessions = recent
        reflectionCount = recent.filter { $0.verdict != .unlogged }.count
        match = Self.score(recent)
        previousMatch = Self.score(state.sessions.filter { $0.enteredAt >= previousStart && $0.enteredAt < start })
        days = (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: start)!
            let entries = recent.filter { calendar.isDate($0.enteredAt, inSameDayAs: date) }
            return Day(date: date, visits: entries.count, reflections: entries.filter { $0.verdict != .unlogged }.count,
                       match: Self.score(entries))
        }
        reasons = Dictionary(grouping: recent, by: \.reason).map { name, entries in
            let durations = entries.compactMap { item -> Double? in
                guard let end = item.closedAt, end >= item.enteredAt, end <= now else { return nil }
                return end.timeIntervalSince(item.enteredAt) / 60
            }
            return Reason(name: name, visits: entries.count,
                          averageMinutes: durations.isEmpty ? nil : max(1, Int((durations.reduce(0, +) / Double(durations.count)).rounded())),
                          match: Self.score(entries))
        }.sorted { $0.visits == $1.visits ? $0.name < $1.name : $0.visits > $1.visits }
    }

    private static func score(_ entries: [SessionRecord]) -> Double? {
        let logged = entries.filter { $0.verdict != .unlogged }
        guard !logged.isEmpty else { return nil }
        return logged.reduce(0.0) { $0 + ($1.verdict == .yes ? 1 : $1.verdict == .partly ? 0.5 : 0) } / Double(logged.count)
    }
}

/// Exports only the user's ledger, never opaque app tokens or internal activity identifiers.
public enum LedgerExport {
    public struct Entry: Codable, Sendable {
        public let app: String
        public let intention: String
        public let began: Date
        public let ended: Date?
        public let verdict: String
        public let note: String?
    }
    public static func entries(_ state: DialogueState) -> [Entry] {
        state.sessions.sorted { $0.enteredAt > $1.enteredAt }.map { session in
            Entry(app: session.appDisplayName ?? state.watchedApps.first { $0.id == session.appID }?.displayName ?? "Removed app",
                  intention: session.reason, began: session.enteredAt, ended: session.closedAt,
                  verdict: session.verdict.rawValue, note: session.note)
        }
    }
    public static func json(_ state: DialogueState) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(entries(state))
    }
    public static func csv(_ state: DialogueState) -> String {
        let formatter = ISO8601DateFormatter()
        func cell(_ value: String) -> String {
            // Prevent a written intention being interpreted as a spreadsheet formula.
            let safe = ["=", "+", "-", "@", "\t", "\r", "\n"].contains(String(value.first ?? " ")) ? "'" + value : value
            return "\"" + safe.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        let rows = entries(state).map { item in
            [item.app, item.intention, formatter.string(from: item.began), item.ended.map(formatter.string) ?? "",
             item.verdict, item.note ?? ""].map(cell).joined(separator: ",")
        }
        return (["App,Intention,Began,Ended,Verdict,Note"] + rows).joined(separator: "\r\n")
    }
}
