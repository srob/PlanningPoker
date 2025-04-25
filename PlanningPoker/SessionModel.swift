//
//  SessionModel.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//


//  SessionModel.swift
//  PlanningPoker

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class SessionModel: ObservableObject {
    @Published var sessionId: String = ""
    @Published var userId: String = UUID().uuidString
    @Published var selectedValue: String? = nil
    @Published var votes: [String: String] = [:] // userId -> value
    @Published var isRevealed: Bool = false
    @Published var participants: [String] = []

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func createSession(completion: @escaping (Result<Void, Error>) -> Void) {
        let sessionRef = db.collection("sessions").document()
        self.sessionId = sessionRef.documentID

        let data: [String: Any] = [
            "createdBy": userId,
            "revealed": false,
            "votes": [:],
            "participants": [userId: true]
        ]
        
        sessionRef.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.listenToSession()
                completion(.success(()))
            }
        }
    }

    func joinSession(sessionId: String) {
        self.sessionId = sessionId
        db.collection("sessions")
          .document(sessionId)
          .setData(["participants.\(userId)": true], merge: true)
        listenToSession()
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
            .addSnapshotListener { snapshot, error in
                guard let data = snapshot?.data(), error == nil else { return }
                
                if let rawParticipants = data["participants"] as? [String: Bool] {
                    self.participants = Array(rawParticipants.keys)
                }

                self.votes = data["votes"] as? [String: String] ?? [:]
                self.isRevealed = data["revealed"] as? Bool ?? false
            }
        
    }

    deinit {
        listener?.remove()
    }
}
