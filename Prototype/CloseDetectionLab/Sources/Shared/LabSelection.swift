import Foundation
#if canImport(FamilyControls)
import FamilyControls

/// Persists the picked apps so the monitor extension can re-shield them
/// from its callbacks. FamilyActivitySelection is Codable; the tokens are
/// opaque and stay on device.
enum LabSelection {
    private static let key = "lab.selection"

    static func save(_ selection: FamilyActivitySelection) {
        guard let defaults = UserDefaults(suiteName: LabLog.suiteName),
              let data = try? JSONEncoder().encode(selection)
        else { return }
        defaults.set(data, forKey: key)
    }

    static func load() -> FamilyActivitySelection? {
        guard let defaults = UserDefaults(suiteName: LabLog.suiteName),
              let data = defaults.data(forKey: key)
        else { return nil }
        return try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    }
}
#endif
