//
//  ModeSelectionView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 25/04/2025.
//


import SwiftUI

struct ModeSelectionView: View {
    @State private var useTeamMode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                Text("Planning Poker")
                    .font(.largeTitle)
                    .bold()

                NavigationLink("👤 Solo Mode", destination: ContentView())
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("SoloModeButton")

                NavigationLink("👥 Team Mode", destination: TeamSessionLobbyView())
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("TeamModeButton")

                Spacer()
            }
            .padding()
        }
    }
}
