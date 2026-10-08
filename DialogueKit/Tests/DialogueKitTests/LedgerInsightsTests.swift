import XCTest
@testable import DialogueKit

final class LedgerInsightsTests: XCTestCase {
    func testWeeklyWindowAndMissingReflections() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        let app = UUID()
        let entries = [
            SessionRecord(appID: app, reason: "Reply", enteredAt: now.addingTimeInterval(-100), verdict: .yes),
            SessionRecord(appID: app, reason: "Reply", enteredAt: now.addingTimeInterval(-200), verdict: .partly),
            SessionRecord(appID: app, reason: "Read", enteredAt: now.addingTimeInterval(-300)),
            SessionRecord(appID: app, reason: "Future", enteredAt: now.addingTimeInterval(100), verdict: .no),
            SessionRecord(appID: app, reason: "Old", enteredAt: now.addingTimeInterval(-8 * 86400), verdict: .no)
        ]
        let summary = LedgerInsights(state: DialogueState(sessions: entries), now: now, calendar: calendar)
        XCTAssertEqual(summary.sessions.count, 3)
        XCTAssertEqual(summary.reflectionCount, 2)
        XCTAssertEqual(summary.match, 0.75)
        XCTAssertEqual(summary.previousMatch, 0)
        XCTAssertEqual(summary.days.count, 7)
        XCTAssertEqual(summary.days.reduce(0) { $0 + $1.visits }, 3)
        XCTAssertEqual(summary.reasons.first?.name, "Reply")
    }
    func testExportExcludesTokensAndEscapesSpreadsheetContent() throws {
        let app = WatchedApp(displayName: "Messages", applicationTokenData: Data("secret-token".utf8))
        let state = DialogueState(watchedApps: [app], sessions: [SessionRecord(
            appID: app.id, reason: "=SUM(1,2)", enteredAt: Date(), note: "A \"quote\"\nand a line",
            monitorActivityName: "private-monitor"
        )])
        let json = String(decoding: try LedgerExport.json(state), as: UTF8.self)
        XCTAssertFalse(json.contains("secret-token"))
        XCTAssertFalse(json.contains("private-monitor"))
        XCTAssertTrue(json.contains("Messages"))
        let csv = LedgerExport.csv(state)
        XCTAssertTrue(csv.contains("\"'=SUM(1,2)\""))
        XCTAssertTrue(csv.contains("A \"\"quote\"\"\nand a line"))
    }
}
