import DialogueKit
import ManagedSettings
import ManagedSettingsUI
import UIKit

/// The gate card. Apple's shield configuration is a fixed template (icon,
/// title, subtitle, primary button, secondary button), so this is the whole
/// canvas, and most users will see it far more often than the app itself.
///
/// Phase 0 renders the template with the ledger tokens and the copy shape
/// ARCHITECTURE.md settled: the app's own name up top, the user's reminder
/// line as the subtitle, dismissal as the cheap primary button, and the
/// reason path as the secondary. The reminder line and the per-app label
/// come from the app group store in phase 2; until then this shows the
/// standing copy. Nothing here may allocate much: the shield runs under a
/// roughly 6MB ceiling, so it never touches SwiftData.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
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

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application)
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
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

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: webDomain)
    }
}
