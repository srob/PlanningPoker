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

            Divider()
            Text("Participants:")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sessionModel.allParticipantIds.sorted(), id: \.self) { userId in
                        VStack {
                            Circle()
                                .fill(sessionModel.votes[userId] != nil ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                            Text(userId.prefix(6))
                                .font(.caption2)
                        }
                    }
                }
                .padding(.horizontal)
            }

            if sessionModel.isRevealed {
                Text("Votes:")
                    .font(.headline)
                ForEach(sessionModel.votes.sorted(by: { $0.key < $1.key }), id: \.key) { userId, value in
                    Text("\(userId.prefix(6)): \(value)")
                }
            } else {
                if sessionModel.votes.count >= 2 {
                    Button("👁 Reveal Votes") {
                        sessionModel.revealVotes()
                    }
                    .padding()
                }
            }

        }
        .padding()
        .navigationTitle("Team Session")

        .overlay(
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
                },
                alignment: .top
        )
    }
}
