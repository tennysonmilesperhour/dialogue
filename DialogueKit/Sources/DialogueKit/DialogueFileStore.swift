import Darwin
import Foundation

/// A separate lock file survives atomic replacement of the ledger. Every process
/// reads the latest state while holding the same lock before making a change.
public struct DialogueFileStore: Sendable {
    public let directory: URL

    public init(directory: URL) { self.directory = directory }

    private struct Record: Codable {
        var state = DialogueState()
        var pendingGate: PendingGateRequest?
    }

    public func load() throws -> DialogueState {
        try transaction { $0.state }
    }

    @discardableResult
    public func update(_ change: (inout DialogueState) -> Void) throws -> DialogueState {
        try transaction { record in
            change(&record.state)
            record.state.normalize()
            return record.state
        }
    }

    public func setPendingGate(_ request: PendingGateRequest) throws {
        try transaction { $0.pendingGate = request }
    }

    public func consumePendingGate() throws -> PendingGateRequest? {
        try transaction { record in
            let request = record.pendingGate
            record.pendingGate = nil
            return request
        }
    }

    public func reset() throws {
        try transaction(discardExisting: true) { $0 = Record() }
    }

    private func transaction<T>(discardExisting: Bool = false, _ body: (inout Record) -> T) throws -> T {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let descriptor = open(directory.appendingPathComponent("dialogue.lock").path, O_CREAT | O_RDWR, 0o600)
        guard descriptor >= 0 else { throw POSIXError(.EIO) }
        defer { close(descriptor) }
        guard flock(descriptor, LOCK_EX) == 0 else { throw POSIXError(.EIO) }
        defer { flock(descriptor, LOCK_UN) }

        let url = directory.appendingPathComponent("dialogue-ledger-v2.json")
        var record: Record
        if discardExisting {
            record = Record()
        } else if FileManager.default.fileExists(atPath: url.path) {
            // Decoding errors are surfaced, never replaced by an empty ledger.
            record = try JSONDecoder().decode(Record.self, from: Data(contentsOf: url))
        } else {
            record = Record()
            if directory == AppGroup.containerURL {
                if let legacy = AppGroup.sharedDefaults?.data(forKey: "dialogue.state.v1") {
                    record.state = try JSONDecoder().decode(DialogueState.self, from: legacy)
                }
                if let gate = AppGroup.sharedDefaults?.data(forKey: "dialogue.pending-gate.v1") {
                    record.pendingGate = try JSONDecoder().decode(PendingGateRequest.self, from: gate)
                }
            }
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let original = try encoder.encode(record)
        let result = body(&record)
        let data = try encoder.encode(record)
        if discardExisting || data != original || !FileManager.default.fileExists(atPath: url.path) {
            #if os(iOS)
            try data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
            #else
            try data.write(to: url, options: .atomic)
            #endif
            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: url.path)
        }
        if directory == AppGroup.containerURL {
            AppGroup.sharedDefaults?.removeObject(forKey: "dialogue.state.v1")
            AppGroup.sharedDefaults?.removeObject(forKey: "dialogue.pending-gate.v1")
        }
        return result
    }
}

public enum SharedDialogueStore {
    private static func store() throws -> DialogueFileStore {
        guard let directory = AppGroup.containerURL else { throw CocoaError(.fileNoSuchFile) }
        return DialogueFileStore(directory: directory)
    }

    public static func load() throws -> DialogueState { try store().load() }
    @discardableResult
    public static func update(_ change: (inout DialogueState) -> Void) throws -> DialogueState {
        try store().update(change)
    }
    public static func setPendingGate(_ request: PendingGateRequest) throws {
        try store().setPendingGate(request)
    }
    public static func consumePendingGate() throws -> PendingGateRequest? {
        try store().consumePendingGate()
    }
    public static func reset() throws { try store().reset() }
}
