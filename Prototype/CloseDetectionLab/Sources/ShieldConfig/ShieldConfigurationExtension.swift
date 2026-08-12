import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Question 4: does the ledger land inside Apple's fixed template?
/// The template gives us: background, icon, title, subtitle, two buttons.
/// Nothing else. This is the whole canvas the gate card gets.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let paper = UIColor(red: 0xF5 / 255, green: 0xF1 / 255, blue: 0xE6 / 255, alpha: 1)
    private let ink = UIColor(red: 0x1C / 255, green: 0x1A / 255, blue: 0x16 / 255, alpha: 1)
    private let ledgerRed = UIColor(red: 0xB2 / 255, green: 0x3A / 255, blue: 0x2F / 255, alpha: 1)

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        LabLog.append(source: "shield", name: "gate_rendered")
        return ShieldConfiguration(
            backgroundBlurStyle: nil,
            backgroundColor: paper,
            icon: nil,
            title: ShieldConfiguration.Label(text: "dialogue", color: ink),
            subtitle: ShieldConfiguration.Label(text: "Was this on purpose?", color: ledgerRed),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Never mind", color: paper),
            primaryButtonBackgroundColor: ink,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Choose a reason", color: ink)
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application)
    }
}
