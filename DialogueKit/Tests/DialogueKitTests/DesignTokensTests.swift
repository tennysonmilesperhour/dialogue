import XCTest
@testable import DialogueKit

final class DesignTokensTests: XCTestCase {
    func testParsesTheLedgerPalette() throws {
        let paper = try XCTUnwrap(DesignTokens.components(hex: DesignTokens.ColorHex.paper))
        XCTAssertEqual(paper.red, 245.0 / 255, accuracy: 0.0001)
        XCTAssertEqual(paper.green, 241.0 / 255, accuracy: 0.0001)
        XCTAssertEqual(paper.blue, 230.0 / 255, accuracy: 0.0001)

        let ink = try XCTUnwrap(DesignTokens.components(hex: DesignTokens.ColorHex.ink))
        XCTAssertEqual(ink.red, 28.0 / 255, accuracy: 0.0001)
        XCTAssertEqual(ink.green, 26.0 / 255, accuracy: 0.0001)
        XCTAssertEqual(ink.blue, 22.0 / 255, accuracy: 0.0001)
    }

    func testAcceptsALeadingHash() {
        XCTAssertEqual(
            DesignTokens.components(hex: "#B23A2F")?.red,
            DesignTokens.components(hex: "B23A2F")?.red
        )
    }

    func testRejectsMalformedTokens() {
        XCTAssertNil(DesignTokens.components(hex: ""))
        XCTAssertNil(DesignTokens.components(hex: "F5F1E"))
        XCTAssertNil(DesignTokens.components(hex: "F5F1E6F"))
        XCTAssertNil(DesignTokens.components(hex: "ZZZZZZ"))
        XCTAssertNil(DesignTokens.components(hex: "+F5F1E"))
    }

    func testEveryPaletteEntryParses() {
        let palette = [
            DesignTokens.ColorHex.paper,
            DesignTokens.ColorHex.ink,
            DesignTokens.ColorHex.ledgerGreen,
            DesignTokens.ColorHex.ledgerRed,
        ]
        for token in palette {
            XCTAssertNotNil(DesignTokens.components(hex: token), "token \(token) does not parse")
        }
    }
}
