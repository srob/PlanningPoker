//
//  TeamSessionLobbyView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 25/04/2025.
//

import SwiftUI

struct TeamSessionLobbyView: View {
    @StateObject var sessionModel = SessionModel()

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Your Name", text: $sessionModel.userName)
                .textFieldStyle(.roundedBorder)

            Button("➕ Create Session") {
                sessionModel.createSession { _ in
                    // hasJoinedSession is set after successful creation
                }
            }

            TextField("Join Session ID", text: $sessionModel.sessionId)
                .textFieldStyle(.roundedBorder)

            Button("🔗 Join Session") {
                sessionModel.joinSession(sessionId: sessionModel.sessionId)
                // hasJoinedSession is set after successful join
            }

            NavigationLink(destination: TeamSessionView(sessionModel: sessionModel), isActive: $sessionModel.hasJoinedSession) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Team Estimation")
        .alert(item: $sessionModel.joinErrorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.text),
                dismissButton: .default(Text("OK")) {
                    sessionModel.joinErrorMessage = nil
                }
            )
        }
    }
}
