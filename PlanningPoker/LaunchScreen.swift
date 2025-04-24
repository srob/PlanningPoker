//
//  LaunchScreen.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 22/04/2025.
//


import SwiftUI

struct LaunchScreen: View {
    @State private var opacity = 1.0

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                Text("Planning Poker")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    opacity = 0.0
                }
            }
        }
    }
}
