//
//  PlanningPokerTests.swift
//  PlanningPokerTests
//
//  Created by Simon Roberts on 21/04/2025.
//

import Testing
@testable import PlanningPoker

struct PlanningPokerTests {

    @Test
    func testVerticalStringTransformation() {
        #expect("13".vertical == "1\n3")
        #expect("?".vertical == "?")
        #expect("100".vertical == "1\n0\n0")
    }

    @Test
    func testAssociatedColorMapping() {
        #expect("?".associatedColor == .purple)
        #expect("1".associatedColor == .blue)
        #expect("5".associatedColor == .green)
        #expect("13".associatedColor == .orange)
        #expect("100".associatedColor == .red)
        #expect("banana".associatedColor == .white) // fallback
    }
}
