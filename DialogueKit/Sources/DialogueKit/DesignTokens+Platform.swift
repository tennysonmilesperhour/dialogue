import Foundation

#if canImport(SwiftUI)
import SwiftUI

extension Color {
    /// Ledger colors for SwiftUI. Falls back to primary if a token is
    /// malformed, which only happens if someone edits a hex string by hand.
    public init(token: String) {
        guard let parts = DesignTokens.components(hex: token) else {
            self = .primary
            return
        }
        self.init(red: parts.red, green: parts.green, blue: parts.blue)
    }

    #if canImport(UIKit)
    public static let paper = Color(uiColor: .paper)
    public static let ink = Color(uiColor: .ink)
    public static let ledgerGreen = Color(uiColor: .ledgerGreen)
    public static let ledgerRed = Color(uiColor: .ledgerRed)
    #else
    public static let paper = Color(token: DesignTokens.ColorHex.paper)
    public static let ink = Color(token: DesignTokens.ColorHex.ink)
    public static let ledgerGreen = Color(token: DesignTokens.ColorHex.ledgerGreen)
    public static let ledgerRed = Color(token: DesignTokens.ColorHex.ledgerRed)
    #endif
}
#endif

#if canImport(UIKit)
import UIKit

extension UIColor {
    /// The shield configuration extension is UIKit only, so the same tokens
    /// have to reach it this way. Same source, no drift.
    public convenience init(token: String) {
        guard let parts = DesignTokens.components(hex: token) else {
            self.init(white: 0, alpha: 1)
            return
        }
        self.init(red: parts.red, green: parts.green, blue: parts.blue, alpha: 1)
    }

    public static var paper: UIColor { UIColor { traits in UIColor(token: traits.userInterfaceStyle == .dark ? "#201F1B" : DesignTokens.ColorHex.paper) } }
    public static var ink: UIColor { UIColor { traits in UIColor(token: traits.userInterfaceStyle == .dark ? "#F5F1E6" : DesignTokens.ColorHex.ink) } }
    public static var ledgerGreen: UIColor { UIColor { traits in UIColor(token: traits.userInterfaceStyle == .dark ? "#9DCAA7" : DesignTokens.ColorHex.ledgerGreen) } }
    public static var ledgerRed: UIColor { UIColor { traits in UIColor(token: traits.userInterfaceStyle == .dark ? "#F0937E" : DesignTokens.ColorHex.ledgerRed) } }
}
#endif
