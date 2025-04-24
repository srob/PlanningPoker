//
//  PlanningPokerUITests.swift
//  PlanningPokerUITests
//
//  Created by Simon Roberts on 21/04/2025.
//

import XCTest

final class PlanningPokerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here before each test
        continueAfterFailure = false
    }

    func testSelectingValueShowsFullScreenView() throws {
        let app = XCUIApplication()
        app.launch()

        // Tap on the first button (e.g., "0")
        let firstButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(firstButton.waitForExistence(timeout: 3), "First value button should appear within 3 seconds")

        let allButtons = app.buttons.allElementsBoundByIndex
        print("Found \(allButtons.count) buttons:")
        for button in allButtons {
            print("- \(button.label)")
        }

        XCTAssertTrue(firstButton.exists, "First value button should exist")
        firstButton.tap()

        // Check that the full-screen text is visible
        let fullScreenText = app.staticTexts["0"]
        XCTAssertTrue(fullScreenText.waitForExistence(timeout: 2), "Full-screen value should appear after tap")
    }
    
    
    func testFullScreenViewDismissesOnTap() {
        let app = XCUIApplication()
        app.launch()

        // Tap a button (e.g. "0")
        let button = app.buttons.element(boundBy: 0)
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Button should exist")
        button.tap()

        // Wait for full-screen value to appear
        let fullScreenText = app.staticTexts["0"]
        XCTAssertTrue(fullScreenText.waitForExistence(timeout: 2), "Full-screen value should appear")

        // Tap anywhere to dismiss
        app.windows.firstMatch.tap()
        
        let disappeared = fullScreenText.waitForNonExistence(timeout: 2)
        XCTAssertTrue(disappeared, "Full-screen value should disappear after tap")

        // Verify grid returns (check for one of the buttons again)
        let reappearedButton = app.buttons["0"]
        XCTAssertTrue(reappearedButton.waitForExistence(timeout: 2), "Button should reappear after dismiss")
    }
    
    func testFullScreenViewAutoDismissesAfterCountdown() {
        let app = XCUIApplication()
        app.launch()

        // Tap a value button (e.g., "0")
        let button = app.buttons.element(boundBy: 0)
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Value button should exist")
        button.tap()

        // Wait for full-screen text to appear
        let fullScreenText = app.staticTexts["0"]
        XCTAssertTrue(fullScreenText.waitForExistence(timeout: 2), "Full-screen value should appear")

        // Wait for the full-screen text to disappear (auto-dismiss after 5 seconds + animation)
        let disappeared = fullScreenText.waitForNonExistence(timeout: 7)
        XCTAssertTrue(disappeared, "Full-screen value should auto-dismiss after countdown")

        // Confirm the grid view returns
        let reappearedButton = app.buttons["0"]
        XCTAssertTrue(reappearedButton.waitForExistence(timeout: 2), "Value button should reappear after auto-dismiss")
    }
}
