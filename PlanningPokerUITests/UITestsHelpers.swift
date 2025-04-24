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
}
