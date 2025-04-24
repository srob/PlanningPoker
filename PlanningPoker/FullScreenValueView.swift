//  FullScreenValueView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.

import SwiftUI
import AVFoundation

struct FullScreenValueView: View {
    let value: String
    let onDismiss: () -> Void

    @State private var remainingTime = 5
    @State private var hasDismissed = false
    @State private var opacity: Double = 1.0
    @State private var animateText = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            value.associatedColor.opacity(0.2).ignoresSafeArea()

            VStack {
                Spacer()
                AnimatedVerticalText(value: value, animate: animateText)
                Spacer()
                CountdownRing(remainingTime: remainingTime, remainingTrim: remainingTrim)
                    .padding(.bottom, 40)
            }
            .opacity(opacity)

            KeyCommandCatcher { key in
                dismissWithAnimation()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismissWithAnimation()
        }
        .onAppear {
            animateText = true
            startCountdown()
        }
    }

    private var remainingTrim: Double {
        return Double(remainingTime) / 5.0
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 1 {
                remainingTime -= 1
            } else {
                timer.invalidate()
                playSound()
                dismissWithAnimation()
            }
        }
    }

    private func dismissWithAnimation() {
        guard !hasDismissed else { return }
        hasDismissed = true

        withAnimation(.easeInOut(duration: 0.5)) {
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onDismiss()
        }
    }

    private func playSound() {
        guard let url = Bundle.main.url(forResource: "analog_bell_ding_reverb", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
