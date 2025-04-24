//
//  CountdownRing.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//


import SwiftUI

struct CountdownRing: View {
    let remainingTime: Int
    let remainingTrim: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                .frame(width: 80, height: 80)

            Circle()
                .trim(from: 0.0, to: CGFloat(remainingTrim))
                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 80, height: 80)
                .animation(.linear(duration: 1.0), value: remainingTime)

            Text("\(remainingTime)")
                .foregroundColor(.gray)
                .font(.headline)
        }
    }
}
