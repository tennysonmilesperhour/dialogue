import DialogueKit
import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let watchedApp = application.token.flatMap(findWatchedApp)
        let title = watchedApp.map { "dialogue · \($0.displayName)" } ?? "dialogue"
        let reminder = watchedApp?.reminderLine.trimmingCharacters(in: .whitespacesAndNewlines)
        let subtitle = reminder?.isEmpty == false ? reminder! : "Was this on purpose?"

        return ShieldConfiguration(
            backgroundBlurStyle: nil,
            backgroundColor: .paper,
            icon: nil,
            title: ShieldConfiguration.Label(text: title, color: .ink),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .ledgerRed),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Never mind", color: .paper),
            primaryButtonBackgroundColor: .ink,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Choose a reason", color: .ink)
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application)
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        fallbackConfiguration
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        fallbackConfiguration
    }

    private func findWatchedApp(for token: ApplicationToken) -> WatchedApp? {
        guard let data = ScreenTimeTokenCodec.encode(token) else { return nil }
        return (try? SharedDialogueStore.load())?.watchedApps.first { $0.applicationTokenData == data }
    }

    private var fallbackConfiguration: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: nil,
            backgroundColor: .paper,
            icon: nil,
            title: ShieldConfiguration.Label(text: "dialogue", color: .ink),
            subtitle: ShieldConfiguration.Label(text: "Was this on purpose?", color: .ledgerRed),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Never mind", color: .paper),
            primaryButtonBackgroundColor: .ink,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Choose a reason", color: .ink)
        )
    }
}
