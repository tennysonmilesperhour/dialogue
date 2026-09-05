import Foundation

struct LabEvent: Codable, Identifiable {
    let id: UUID
    let at: Date
    let source: String
    let name: String
    let detail: String
}

/// Shared event timeline across all four processes, in app group defaults.
/// Cross-process writes can race; for a lab that occasionally drops an event
/// under contention that is acceptable. Production uses one writer per store.
enum LabLog {
    static let suiteName = "group.app.dialogue"
    private static let key = "lab.events"

    static func append(source: String, name: String, detail: String = "") {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        var events = load()
        events.append(LabEvent(id: UUID(), at: Date(), source: source, name: name, detail: detail))
        if events.count > 2000 {
            events.removeFirst(events.count - 2000)
        }
        if let data = try? JSONEncoder().encode(events) {
            defaults.set(data, forKey: key)
        }
    }

    static func load() -> [LabEvent] {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: key),
              let events = try? JSONDecoder().decode([LabEvent].self, from: data)
        else { return [] }
        return events
    }

    static func clear() {
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
    }

    static func exportJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(load()) else { return "[]" }
        return String(decoding: data, as: UTF8.self)
    }
}
