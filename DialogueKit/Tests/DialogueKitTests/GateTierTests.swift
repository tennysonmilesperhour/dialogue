import XCTest
@testable import DialogueKit

final class GateTierTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_700_000_000)

    func testTargetMappingAtBoundaries() {
        XCTAssertEqual(GateTier.target(forIMS: 0.85), .whisper)
        XCTAssertEqual(GateTier.target(forIMS: 0.849), .standard)
        XCTAssertEqual(GateTier.target(forIMS: 0.60), .standard)
        XCTAssertEqual(GateTier.target(forIMS: 0.599), .deliberate)
        XCTAssertEqual(GateTier.target(forIMS: 0.0), .deliberate)
        XCTAssertEqual(GateTier.target(forIMS: 1.0), .whisper)
    }

    func testNoDataKeepsCurrentTier() {
        let next = GateTier.next(
            current: .standard, ims: nil, loggedSessions: 0, lastChangedAt: nil, now: now
        )
        XCTAssertEqual(next, .standard)
    }

    func testMinimumSessionsHoldsStandard() {
        let next = GateTier.next(
            current: .standard, ims: 0.95, loggedSessions: 11, lastChangedAt: nil, now: now
        )
        XCTAssertEqual(next, .standard)
    }

    func testMovesToWhisperWithEnoughSessions() {
        let next = GateTier.next(
            current: .standard, ims: 0.95, loggedSessions: 12, lastChangedAt: nil, now: now
        )
        XCTAssertEqual(next, .whisper)
    }

    func testSeventyTwoHourClampBlocksThrash() {
        let recentChange = now.addingTimeInterval(-71 * 3600)
        let next = GateTier.next(
            current: .whisper, ims: 0.10, loggedSessions: 30, lastChangedAt: recentChange, now: now
        )
        XCTAssertEqual(next, .whisper)
    }

    func testChangeAllowedAfterClampExpires() {
        let staleChange = now.addingTimeInterval(-73 * 3600)
        let next = GateTier.next(
            current: .whisper, ims: 0.10, loggedSessions: 30, lastChangedAt: staleChange, now: now
        )
        XCTAssertEqual(next, .deliberate)
    }

    func testSettleSecondsPerTier() {
        XCTAssertEqual(GateTier.whisper.settleSeconds, 0)
        XCTAssertEqual(GateTier.standard.settleSeconds, 3)
        XCTAssertEqual(GateTier.deliberate.settleSeconds, 8)
        XCTAssertTrue(GateTier.deliberate.requiresTypedWord)
        XCTAssertFalse(GateTier.standard.requiresTypedWord)
    }
}
