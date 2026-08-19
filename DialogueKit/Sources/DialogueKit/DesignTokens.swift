import Foundation

/// Analog ledger, not wellness app. Ink on paper. These constants are the
/// single source of truth for app, extensions, and (mirrored by hand) the
/// web. If a value changes here, grep the web styles for its old value.
public enum DesignTokens {
    public enum ColorHex {
        /// Warm cream paper.
        public static let paper = "F5F1E6"
        /// Near-black ink for entries.
        public static let ink = "1C1A16"
        /// Bookkeeping green for kept intentions.
        public static let ledgerGreen = "2E5E3F"
        /// Ledger red for the margin rule, reminders, and broken intentions.
        public static let ledgerRed = "B23A2F"
    }

    public enum Layout {
        /// The single red margin rule down the left, in points.
        public static let marginRuleX: Double = 26
        /// Hard borders. No soft blur; the weight is the point.
        public static let borderWidth: Double = 1.5
    }

    /// Splits a six digit hex string into components in 0...1. Nil for any
    /// string that is not six hex digits, so a typo in a token fails loudly
    /// at the call site instead of rendering as black.
    public static func components(hex: String) -> (red: Double, green: Double, blue: Double)? {
        let digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard digits.count == 6, digits.allSatisfy(\.isHexDigit),
              let value = UInt32(digits, radix: 16)
        else { return nil }
        return (
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }

    public enum FontName {
        /// Display and app names.
        public static let display = "Fraunces"
        /// Every number, label, and timestamp. Tabular figures always.
        public static let mono = "IBM Plex Mono"
        /// Body and the user's own written lines, italic.
        public static let serif = "IBM Plex Serif"
    }
}
