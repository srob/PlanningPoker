//  VerticalValueText.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.

import SwiftUI

struct VerticalValueText: View {
    let value: String
    let animate: Bool

    var body: some View {
        Text(value.vertical)
            .font(.system(size: 120, weight: .bold))
            .foregroundColor(value.associatedColor)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .minimumScaleFactor(0.2)
            .fixedSize()
            .scaleEffect(animate ? 1.0 : 0.5)
            .opacity(animate ? 1 : 0)
            .animation(.easeOut(duration: 0.6), value: animate)
            .accessibilityIdentifier("FullScreenValueText")
    }
}
