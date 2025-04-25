//
//  TeamSessionLobbyView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 25/04/2025.
//


import SwiftUI

struct TeamSessionLobbyView: View {
    @StateObject var sessionModel = SessionModel()
    @State private var isInSession = false

    var body: some View {
        VStack(spacing: 20) {
            Button("➕ Create Session") {
                sessionModel.createSession { _ in
                    isInSession = true
                }
            }

            TextField("Join Session ID", text: $sessionModel.sessionId)
                .textFieldStyle(.roundedBorder)

            Button("🔗 Join Session") {
                sessionModel.joinSession(sessionId: sessionModel.sessionId)
                isInSession = true
            }

            NavigationLink(destination: TeamSessionView(sessionModel: sessionModel), isActive: $isInSession) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Team Estimation")
    }
}
