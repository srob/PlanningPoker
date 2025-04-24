//
//  Extensions.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//

import SwiftUI

extension String {
    var vertical: String {
        self.map { String($0) }.joined(separator: "\n")
    }

    var associatedColor: Color {
        switch self {
        case "?": return .purple
        case "0", "1", "2": return .blue
        case "3", "5": return .green
        case "8", "13": return .orange
        case "20", "40", "100": return .red
        default: return .white
        }
    }
}
