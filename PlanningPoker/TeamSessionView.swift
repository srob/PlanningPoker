//
//  TeamSessionView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 25/04/2025.
//

import SwiftUI

struct TeamSessionView: View {
    @ObservedObject var sessionModel: SessionModel
    @State private var showCopiedAlert = false

    let values = ["0", "1", "2", "3", "5", "8", "13", "20", "40", "100", "?"]

    var body: some View {
        VStack(spacing: 20) {
            sessionInfoView
            estimateGrid
            Divider()
            participantsList
            votesSection
        }
        .padding()
        .navigationTitle("Team Session")
        .overlay(copiedAlertOverlay, alignment: .top)
    }

    // MARK: - Sections

    private var sessionInfoView: some View {
        HStack(spacing: 8) {
            Text("Session ID:")
            Text(sessionModel.sessionId)
                .font(.caption)
                .monospaced()
                .lineLimit(1)
                .truncationMode(.middle)
                .foregroundColor(.blue)

            Button(action: {
                UIPasteboard.general.string = sessionModel.sessionId
                showCopiedAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopiedAlert = false
                }
            }) {
                Image(systemName: "doc.on.doc")
            }
            .accessibilityLabel("Copy session ID")
        }
        .padding(.top)
    }

    private var estimateGrid: some View {
        VStack {
            Text("Tap your estimate")
                .font(.title2)
                .padding()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                ForEach(values, id: \.self) { value in
                    Button(action: {
                        sessionModel.selectValue(value)
                    }) {
                        Text(value)
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    private var participantsList: some View {
        VStack {
            Text("Participants:")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sessionModel.participants.sorted(), id: \.self) { userId in
                        ParticipantView(
                            name: displayName(for: userId),
                            hasVoted: sessionModel.votes[userId] != nil
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var votesSection: some View {
        VStack {
            if sessionModel.isRevealed {
                Text("Votes:")
                    .font(.headline)

                ForEach(sessionModel.votes.sorted(by: { $0.key < $1.key }), id: \.key) { userId, value in
                    Text("\(displayName(for: userId)): \(value)")
                }

                if sessionModel.isCreator {
                    Button("🙈 Hide Votes") {
                        sessionModel.hideVotes()
                    }
                    .padding()
                }

            } else {
                if sessionModel.votes.count >= 2 && sessionModel.isCreator {
                    Button("👁 Reveal Votes") {
                        sessionModel.revealVotes()
                    }
                    .padding()
                }
            }
        }
    }

    private var copiedAlertOverlay: some View {
        Group {
            if showCopiedAlert {
                Text("Copied!")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    // MARK: - Helpers

    private func displayName(for userId: String) -> String {
        if let name = sessionModel.participantNames[userId], !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name
        } else {
            return String(userId.prefix(6))
        }
    }
}

// MARK: - ParticipantView for individual participant bubbles

private struct ParticipantView: View {
    let name: String
    let hasVoted: Bool

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(hasVoted ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)

                if hasVoted {
                    Image(systemName: "checkmark")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            }
            Text(name)
                .font(.caption2)
                .lineLimit(1)
                .frame(width: 50)
        }
    }
}
