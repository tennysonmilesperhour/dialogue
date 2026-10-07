import XCTest

@MainActor
final class DialogueUITests: XCTestCase {
    private func launchSample(extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-sample-ledger"] + extra
        app.launch()
        XCTAssertTrue(app.buttons["exitSample"].waitForExistence(timeout: 15))
        return app
    }
    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        let scroll = app.scrollViews.firstMatch
        for _ in 0..<16 {
            let viewport = scroll.exists ? scroll.frame : app.frame
            let top = viewport.minY + 12
            let bottom = min(viewport.maxY, app.tabBars.firstMatch.exists ? app.tabBars.firstMatch.frame.minY : app.frame.maxY - 24) - 16
            if element.exists {
                let frame = element.frame
                // isHittable alone can include controls covered by the floating tab bar.
                if element.isHittable && frame.minY >= top && frame.maxY <= bottom { return }
                if frame.minY < top {
                    scroll.swipeDown()
                } else {
                    scroll.swipeUp()
                }
            } else {
                scroll.swipeUp()
            }
        }
        XCTFail("Could not bring the complete control into the visible content area")
    }
    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    func testIntentionReflectionUndoAndLedgerSearch() {
        let app = launchSample()
        capture("01-today")
        let begin = app.buttons["Begin visit to Instagram"]
        reveal(begin, in: app)
        begin.tap()
        XCTAssertTrue(app.buttons["beginVisit"].waitForExistence(timeout: 5))
        capture("02-intention")
        app.buttons["Reply"].tap()
        reveal(app.buttons["beginVisit"], in: app)
        app.buttons["beginVisit"].tap()
        let finish = app.buttons["endVisit"]
        XCTAssertTrue(finish.waitForExistence(timeout: 5))
        reveal(finish, in: app)
        finish.tap()
        XCTAssertTrue(app.buttons["verdict-yes"].waitForExistence(timeout: 5))
        capture("03-reflection")
        app.buttons["verdict-yes"].tap()
        reveal(app.buttons["logReflection"], in: app)
        app.buttons["logReflection"].tap()
        XCTAssertTrue(app.buttons["Undo"].waitForExistence(timeout: 5))
        app.buttons["Undo"].tap()
        XCTAssertTrue(app.buttons["verdict-partly"].waitForExistence(timeout: 5))
        app.buttons["verdict-partly"].tap()
        reveal(app.buttons["logReflection"], in: app)
        app.buttons["logReflection"].tap()
        XCTAssertTrue(app.buttons["Dismiss confirmation"].waitForExistence(timeout: 5))
        app.buttons["Dismiss confirmation"].tap()
        app.tabBars.buttons["Ledger"].tap()
        capture("04-ledger")
        app.textFields["ledgerSearch"].tap()
        app.textFields["ledgerSearch"].typeText("NoSuchIntentionHere")
        XCTAssertTrue(app.staticTexts["No matching entries."].waitForExistence(timeout: 5))
        app.buttons["Clear search"].tap()
        app.tabBars.buttons["Review"].tap()
        capture("05-review")
        app.tabBars.buttons["Settings"].tap()
        capture("06-settings")
        app.buttons["exitSample"].tap()
        XCTAssertTrue(app.buttons["beginSetup"].waitForExistence(timeout: 5))
        // Unsigned CI runners have no App Group container. Verify the fail-open
        // message, acknowledge it, and then capture the permission-free welcome.
        let storageAlert = app.alerts["A note from dialogue"]
        if storageAlert.waitForExistence(timeout: 1) {
            XCTAssertTrue(storageAlert.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "Gates are open while storage is unavailable")).firstMatch.exists)
            storageAlert.buttons["OK"].tap()
        }
        XCTAssertTrue(app.buttons["beginSetup"].isHittable)
        capture("07-welcome")
    }
    func testLargeTextReflectionRemainsReachable() {
        let app = launchSample(extra: ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"])
        let reflect = app.buttons["reflectNow"]
        reveal(reflect, in: app)
        reflect.tap()
        let yes = app.buttons["verdict-yes"]
        XCTAssertTrue(yes.waitForExistence(timeout: 5))
        reveal(yes, in: app)
        yes.tap()
        reveal(app.buttons["logReflection"], in: app)
        capture("08-accessibility-reflection")
        app.buttons["logReflection"].tap()
        XCTAssertTrue(app.buttons["Undo"].waitForExistence(timeout: 5))
    }
    func testDarkAppearanceReview() {
        let app = launchSample(extra: ["-test-dark-appearance"])
        app.tabBars.buttons["Review"].tap()
        XCTAssertTrue(app.staticTexts["Your week\nin intentions."].waitForExistence(timeout: 5))
        capture("09-dark-review")
    }
    func testPauseDoesNotLoseTheSampleLedger() {
        let app = launchSample()
        app.tabBars.buttons["Settings"].tap()
        let pause = app.switches["Pause all gates"]
        XCTAssertTrue(pause.waitForExistence(timeout: 5))
        pause.tap()
        app.tabBars.buttons["Today"].tap()
        XCTAssertTrue(app.staticTexts["Gates are paused"].waitForExistence(timeout: 5))
        app.buttons["Resume gates"].tap()
        app.tabBars.buttons["Ledger"].tap()
        XCTAssertTrue(app.textFields["ledgerSearch"].waitForExistence(timeout: 5))
    }
}
