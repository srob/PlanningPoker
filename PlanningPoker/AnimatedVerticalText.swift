//
//  AnimatedVerticalText.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//


import SwiftUI

struct AnimatedVerticalText: View {
    let value: String
    let animate: Bool

    var body: some View {
        VerticalValueText(value: value, animate: animate)
    }
}
