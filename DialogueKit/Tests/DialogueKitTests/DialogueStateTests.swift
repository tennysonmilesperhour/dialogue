import XCTest
@testable import DialogueKit

final class DialogueStateTests: XCTestCase {
    func testQueueRepairsStaleAndMissingIDsAndExcludesActiveVisits() {
        let closed = SessionRecord(appID: UUID(), reason: "Reply", enteredAt: Date(), closedAt: Date())
        let active = SessionRecord(appID: UUID(), reason: "Look up", enteredAt: Date())
        let logged = SessionRecord(appID: UUID(), reason: "Bored", enteredAt: Date(), closedAt: Date(), verdict: .yes)
        var state = DialogueState(sessions: [closed, active, logged], pendingDebriefIDs: [UUID(), logged.id])
        state.normalize()
        XCTAssertEqual(state.pendingDebriefIDs, [closed.id])
        XCTAssertEqual(state.activeAppIDs, [active.appID])
    }

    func testActiveVisitStaysOpenOnRefreshAndPauseOpensEveryApp() {
        let app = WatchedApp(displayName: "Social")
        let other = WatchedApp(displayName: "Messages")
        let session = SessionRecord(appID: app.id, reason: "Reply", enteredAt: Date())
        var state = DialogueState(watchedApps: [app, other], sessions: [session])
        XCTAssertEqual(state.shieldedAppIDs, [other.id])
        state.sessions[0].closedAt = Date()
        XCTAssertEqual(state.shieldedAppIDs, [app.id, other.id])
        state.isPaused = true
        XCTAssertTrue(state.shieldedAppIDs.isEmpty)
    }

    func testConcurrentWritersPreserveEveryEntry() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = DialogueFileStore(directory: directory)
        DispatchQueue.concurrentPerform(iterations: 100) { index in
            do {
                try store.update {
                    $0.sessions.append(SessionRecord(appID: UUID(), reason: "Entry \(index)", enteredAt: Date()))
                }
            } catch { XCTFail("Transaction failed: \(error)") }
        }
        XCTAssertEqual(try store.load().sessions.count, 100)
        XCTAssertEqual(Set(try store.load().sessions.map(\.reason)).count, 100)
    }

    func testCorruptDataIsNotOverwritten() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("dialogue-ledger-v2.json")
        let original = Data("corrupt record".utf8)
        try original.write(to: url)
        XCTAssertThrowsError(try DialogueFileStore(directory: directory).update { $0.isPaused = true })
        XCTAssertEqual(try Data(contentsOf: url), original)
        // Explicit deletion must also work when the previous record is unreadable.
        try DialogueFileStore(directory: directory).reset()
        XCTAssertEqual(try DialogueFileStore(directory: directory).load(), DialogueState())
    }

    func testPendingGateIsConsumedOnceAndResetClearsIt() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = DialogueFileStore(directory: directory)
        let request = PendingGateRequest(applicationTokenData: Data([1]))
        try store.setPendingGate(request)
        XCTAssertEqual(try store.consumePendingGate(), request)
        XCTAssertNil(try store.consumePendingGate())
        try store.setPendingGate(request)
        try store.update { $0.isPaused = true }
        try store.reset()
        XCTAssertEqual(try store.load(), DialogueState())
        XCTAssertNil(try store.consumePendingGate())
    }
}
