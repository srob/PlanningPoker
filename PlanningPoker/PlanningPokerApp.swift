//
//  PlanningPokerApp.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 21/04/2025.
//

import SwiftUI
import Firebase

@main
struct PlanningPokerApp: App {
    @State private var showSplash = true
    
    init() {
        FirebaseApp.configure();
    }

    var body: some Scene {
        WindowGroup {
            if showSplash {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}

