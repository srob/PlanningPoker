//
//  KeyCommandCatcher.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//


import SwiftUI
import UIKit

struct KeyCommandCatcher: UIViewControllerRepresentable {
    var onKeyPress: (String) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onKeyPress: onKeyPress)
    }

    class Coordinator: UIViewController {
        var onKeyPress: (String) -> Void

        init(onKeyPress: @escaping (String) -> Void) {
            self.onKeyPress = onKeyPress
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var canBecomeFirstResponder: Bool { true }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            becomeFirstResponder()
        }

        override var keyCommands: [UIKeyCommand]? {
            [
                UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(handleKey(_:))),
                UIKeyCommand(input: " ", modifierFlags: [], action: #selector(handleKey(_:)))
            ]
        }

        @objc func handleKey(_ command: UIKeyCommand) {
            if let input = command.input {
                onKeyPress(input)
            }
        }
    }
}
