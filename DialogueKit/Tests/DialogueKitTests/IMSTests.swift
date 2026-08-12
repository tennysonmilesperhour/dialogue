import XCTest
@testable import DialogueKit

final class IMSTests: XCTestCase {
    private let appID = UUID()
    private let now = Date(timeIntervalSince1970: 1_700_000_000)

    private func session(_ verdict: Verdict, daysAgo: Double = 1) -> SessionRecord {
        SessionRecord(
            appID: appID,
            reason: "Reply",
            enteredAt: now.addingTimeInterval(-daysAgo * 86_400),
            verdict: verdict
        )
    }

    func testAllYesIsPerfect() {
        let sessions = [session(.yes), session(.yes), session(.yes)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 1.0)
    }

    func testPartlyCountsHalf() {
        let sessions = [session(.yes), session(.partly)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 0.75)
    }

    func testAllNoIsZero() {
        let sessions = [session(.no), session(.no)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 0.0)
    }

    func testUnloggedExcludedEntirely() {
        let sessions = [session(.yes), session(.unlogged), session(.unlogged)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 1.0)
    }

    func testOnlyUnloggedIsNoData() {
        let sessions = [session(.unlogged), session(.unlogged)]
        XCTAssertNil(IMS.score(sessions: sessions, asOf: now))
    }

    func testEmptyIsNoData() {
        XCTAssertNil(IMS.score(sessions: [], asOf: now))
    }

    func testWindowExcludesOldSessions() {
        let sessions = [session(.no, daysAgo: 15), session(.yes, daysAgo: 2)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 1.0)
    }

    func testWindowExcludesFutureSessions() {
        let sessions = [session(.no, daysAgo: -1), session(.yes, daysAgo: 1)]
        XCTAssertEqual(IMS.score(sessions: sessions, asOf: now), 1.0)
    }

    func testLoggedCountIgnoresUnloggedAndOld() {
        let sessions = [
            session(.yes, daysAgo: 1),
            session(.no, daysAgo: 2),
            session(.unlogged, daysAgo: 3),
            session(.yes, daysAgo: 20),
        ]
        XCTAssertEqual(IMS.loggedCount(sessions: sessions, asOf: now), 2)
    }

    func testDisplayStringRounds() {
        XCTAssertEqual(IMS.displayString(0.875), "88%")
        XCTAssertEqual(IMS.displayString(1.0), "100%")
        XCTAssertEqual(IMS.displayString(0.0), "0%")
    }
}
