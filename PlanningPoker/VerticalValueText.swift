//
//  VerticalValueText.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//

import SwiftUI

struct VerticalValueText: View {
    let value: String
    let animate: Bool

    var body: some View {
        VStack(spacing: -15) { // tighten slightly if needed
            ForEach(Array(value), id: \.self) { char in
                Text(String(char))
                    .font(.system(size: 150, weight: .bold)) // <-- BIGGER FONT
                    .foregroundColor(value.associatedColor)
                    .frame(height: 130) // <-- Adjust frame to fit bigger font
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        .scaleEffect(animate ? 1.0 : 0.5)
        .opacity(animate ? 1 : 0)
        .animation(.easeOut(duration: 0.6), value: animate)
        .accessibilityIdentifier("FullScreenValueText")
    }
}
