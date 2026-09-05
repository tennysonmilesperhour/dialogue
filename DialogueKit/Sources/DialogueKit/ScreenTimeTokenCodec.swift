#if os(iOS) && canImport(ManagedSettings)
import Foundation
import ManagedSettings

public enum ScreenTimeTokenCodec {
    public static func encode(_ token: ApplicationToken) -> Data? {
        try? JSONEncoder().encode(token)
    }

    public static func decode(_ data: Data?) -> ApplicationToken? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(ApplicationToken.self, from: data)
    }
}

public enum DialogueScreenTime {
    public static let managedStoreName = "dialogue"
    public static let activityPrefix = "dialogue.session."
    public static let budgetEventName = "dialogue.budget"

    public static func sessionID(from activityName: String) -> UUID? {
        guard activityName.hasPrefix(activityPrefix) else { return nil }
        return UUID(uuidString: String(activityName.dropFirst(activityPrefix.count)))
    }
}

public enum DialogueShieldController {
    public static func apply(_ state: DialogueState) {
        let store = ManagedSettingsStore(
            named: ManagedSettingsStore.Name(DialogueScreenTime.managedStoreName)
        )
        guard !state.isPaused else {
            store.clearAllSettings()
            return
        }
        let tokens: Set<ApplicationToken> = Set(state.watchedApps.compactMap {
            ScreenTimeTokenCodec.decode($0.applicationTokenData)
        })
        store.shield.applications = tokens.isEmpty ? nil : tokens
    }

    public static func allow(_ applicationTokenData: Data, in state: DialogueState) {
        let store = ManagedSettingsStore(
            named: ManagedSettingsStore.Name(DialogueScreenTime.managedStoreName)
        )
        let tokens: Set<ApplicationToken> = Set(state.watchedApps.compactMap {
            guard $0.applicationTokenData != applicationTokenData else { return nil }
            return ScreenTimeTokenCodec.decode($0.applicationTokenData)
        })
        store.shield.applications = tokens.isEmpty ? nil : tokens
    }
}
#endif
