//
//  UITestsHelpers.swift
//  PlanningPokerUITests
//
//  Created by Simon Roberts on 24/04/2025.
//

import XCTest

extension XCUIElement {
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func enterSoloMode() {
        let soloModeButton = buttons["SoloModeButton"]
        XCTAssertTrue(soloModeButton.waitForExistence(timeout: 3), "Solo Mode button should appear")
        soloModeButton.tap()
    }
    
    func waitUntilExists(timeout: TimeInterval = 5) -> Bool {
        let existsPredicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func waitUntilNotExists(timeout: TimeInterval = 5) -> Bool {
        let notExistsPredicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: notExistsPredicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
