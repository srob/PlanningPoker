//
//  SessionModel.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//

import Foundation
import FirebaseFirestore

struct ErrorMessage: Identifiable {
    var id: String { text }
    let text: String
}

class SessionModel: ObservableObject {
    @Published var sessionId: String = ""
    @Published var userId: String = UUID().uuidString
    @Published var userName: String = "" // NEW: entered participant name
    @Published var selectedValue: String? = nil
    @Published var votes: [String: String] = [:] // userId -> value
    @Published var isRevealed: Bool = false
    @Published var participants: [String] = []
    @Published var participantNames: [String: String] = [:] // NEW: userId -> name
    @Published var joinErrorMessage: ErrorMessage? = nil
    @Published var hasJoinedSession: Bool = false

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func createSession(completion: @escaping (Result<Void, Error>) -> Void) {
        let sessionRef = db.collection("sessions").document()
        self.sessionId = sessionRef.documentID

        let data: [String: Any] = [
            "createdBy": userId,
            "revealed": false,
            "votes": [:],
            "participants": [userId: userName]
        ]

        sessionRef.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.listenToSession()
                DispatchQueue.main.async {
                    self.hasJoinedSession = true
                }
                completion(.success(()))
            }
        }
    }

    func joinSession(sessionId: String) {
        let trimmedSessionId = sessionId.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSessionId.isEmpty else {
            DispatchQueue.main.async {
                self.joinErrorMessage = ErrorMessage(text: "Session ID cannot be empty.")
            }
            return
        }

        self.sessionId = trimmedSessionId

        let sessionRef = db.collection("sessions").document(trimmedSessionId)

        sessionRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error checking session: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.joinErrorMessage = ErrorMessage(text: "Failed to connect. Please try again.")
                }
                return
            }

            if let document = document, document.exists {
                sessionRef.updateData(["participants.\(self.userId)": self.userName]) { error in
                    if let error = error {
                        print("❌ Error joining session: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.joinErrorMessage = ErrorMessage(text: "Failed to join session. Please try again.")
                        }
                    } else {
                        print("✅ Successfully joined session and added participant: \(self.userId)")
                        self.listenToSession()
                        DispatchQueue.main.async {
                            self.hasJoinedSession = true
                        }
                    }
                }
            } else {
                print("❌ Session does not exist.")
                DispatchQueue.main.async {
                    self.joinErrorMessage = ErrorMessage(text: "Session not found. Please check the session ID.")
                }
            }
        }
    }

    func selectValue(_ value: String) {
        guard !sessionId.isEmpty else { return }
        selectedValue = value
        db.collection("sessions")
            .document(sessionId)
            .updateData(["votes.\(userId)": value])
    }

    func revealVotes() {
        guard !sessionId.isEmpty else { return }
        db.collection("sessions")
            .document(sessionId)
            .updateData(["revealed": true])
    }

    var allParticipantIds: [String] {
        return participants.isEmpty ? Array(Set(votes.keys + [userId])) : participants
    }

    private func listenToSession() {
        guard !sessionId.isEmpty else { return }

        listener?.remove()

        listener = db.collection("sessions")
            .document(sessionId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                guard let document = documentSnapshot else {
                    print("Error fetching session snapshot: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let data = document.data() {
                    DispatchQueue.main.async {
                        self.votes = data["votes"] as? [String: String] ?? [:]
                        self.isRevealed = data["revealed"] as? Bool ?? false
                        let participantsDict = data["participants"] as? [String: String] ?? [:]
                        self.participantNames = participantsDict
                        self.participants = Array(participantsDict.keys)
                        print("👥 Participants received from Firestore: \(participantsDict)")
                    }
                }
            }
    }

    deinit {
        listener?.remove()
    }
}
