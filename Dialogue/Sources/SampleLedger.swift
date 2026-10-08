import DialogueKit
import Foundation

/// Fictional entries in memory. Exploring the sample never changes the real ledger or shields.
enum SampleLedger {
    static func make(now: Date = Date()) -> DialogueState {
        let apps = [WatchedApp(displayName: "Instagram", reminderLine: "Catch up with someone you care about."),
                    WatchedApp(displayName: "YouTube", reminderLine: "What did you come to learn?"),
                    WatchedApp(displayName: "Reddit", reminderLine: "Find an answer, then carry on.")]
        let reasons = ["Reply", "Look up", "Bored", "Reply", "Learn something", "Avoiding something"]
        var sessions: [SessionRecord] = []
        for day in 0..<7 {
            for visit in 0..<3 {
                let index = day * 3 + visit
                let date = now.addingTimeInterval(-Double(day * 86400 + visit * 2400 + 1200))
                sessions.append(SessionRecord(appID: apps[visit].id, reason: reasons[index % reasons.count],
                    enteredAt: date, closedAt: date.addingTimeInterval(Double([180, 420, 660][visit])),
                    closeSource: .threshold, verdict: index == 0 ? .unlogged : index % 5 == 0 ? .no : index % 3 == 0 ? .partly : .yes,
                    note: index == 2 ? "Found the answer I came for." : nil, appDisplayName: apps[visit].displayName))
            }
        }
        return DialogueState(watchedApps: apps, sessions: sessions,
                             dismissals: [Dismissal(appID: apps[0].id, occurredAt: now, gateTier: .standard)],
                             onboardingCompleted: true)
    }
}
