//
//  PlanningPokerUITests.swift
//  PlanningPokerUITests
//
//  Created by Simon Roberts on 21/04/2025.
//

import XCTest

final class PlanningPokerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSelectingValueShowsFullScreenView() throws {
        let app = XCUIApplication()
        app.launch()
        app.enterSoloMode()

        let zeroButton = app.buttons["0"]
        XCTAssertTrue(zeroButton.waitUntilExists(timeout: 3), "Button labeled '0' should appear within 3 seconds")
        zeroButton.tap()

        let fullScreenContainer = app.otherElements["FullScreenContainer"]
        XCTAssertTrue(fullScreenContainer.waitUntilExists(timeout: 5), "Full-screen view should appear after tap")
    }

    func testFullScreenViewDismissesOnTap() {
        let app = XCUIApplication()
        app.launch()
        app.enterSoloMode()

        let zeroButton = app.buttons["0"]
        XCTAssertTrue(zeroButton.waitUntilExists(timeout: 2), "Button labeled '0' should exist")
        zeroButton.tap()

        let fullScreenContainer = app.otherElements["FullScreenContainer"]
        XCTAssertTrue(fullScreenContainer.waitUntilExists(timeout: 5), "Full-screen view should appear")

        app.windows.firstMatch.tap()

        let disappeared = fullScreenContainer.waitUntilNotExists(timeout: 5)
        XCTAssertTrue(disappeared, "Full-screen view should disappear after tap")

        let reappearedButton = app.buttons["0"]
        XCTAssertTrue(reappearedButton.waitUntilExists(timeout: 2), "Button labeled '0' should reappear after dismiss")
    }

    func testFullScreenViewAutoDismissesAfterCountdown() {
        let app = XCUIApplication()
        app.launch()
        app.enterSoloMode()

        let zeroButton = app.buttons["0"]
        XCTAssertTrue(zeroButton.waitUntilExists(timeout: 2), "Button labeled '0' should exist")
        zeroButton.tap()

        let fullScreenContainer = app.otherElements["FullScreenContainer"]
        XCTAssertTrue(fullScreenContainer.waitUntilExists(timeout: 5), "Full-screen view should appear")

        let disappeared = fullScreenContainer.waitUntilNotExists(timeout: 7)
        XCTAssertTrue(disappeared, "Full-screen view should auto-dismiss after countdown")

        let reappearedButton = app.buttons["0"]
        XCTAssertTrue(reappearedButton.waitUntilExists(timeout: 2), "Button labeled '0' should reappear after auto-dismiss")
    }
}
