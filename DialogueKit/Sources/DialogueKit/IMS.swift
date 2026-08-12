import Foundation

/// Intention Match Score. The one metric. Always derived, never stored raw.
///
///     IMS(app, 14d) = (yes + 0.5 * partly) / (yes + partly + no)
///
/// Unlogged sessions are excluded from numerator and denominator.
public enum IMS {
    public static let windowDays = 14

    /// Returns the score in 0...1, or nil when no logged sessions fall in
    /// the window. Callers must treat nil as "no data yet", never as zero.
    public static func score(
        sessions: [SessionRecord],
        asOf now: Date = Date(),
        windowDays: Int = IMS.windowDays
    ) -> Double? {
        let cutoff = now.addingTimeInterval(-Double(windowDays) * 86_400)
        var yes = 0
        var partly = 0
        var no = 0
        for session in sessions where session.enteredAt >= cutoff && session.enteredAt <= now {
            switch session.verdict {
            case .yes: yes += 1
            case .partly: partly += 1
            case .no: no += 1
            case .unlogged: continue
            }
        }
        let denominator = yes + partly + no
        guard denominator > 0 else { return nil }
        return (Double(yes) + 0.5 * Double(partly)) / Double(denominator)
    }

    /// Logged sessions in the window; the tier engine needs this to enforce
    /// its minimum before moving off standard.
    public static func loggedCount(
        sessions: [SessionRecord],
        asOf now: Date = Date(),
        windowDays: Int = IMS.windowDays
    ) -> Int {
        let cutoff = now.addingTimeInterval(-Double(windowDays) * 86_400)
        return sessions.filter {
            $0.enteredAt >= cutoff && $0.enteredAt <= now && $0.verdict != .unlogged
        }.count
    }

    /// Display form, tabular-figure friendly: "88%". Rounds half up.
    public static func displayString(_ score: Double) -> String {
        "\(Int((score * 100).rounded()))%"
    }
}
