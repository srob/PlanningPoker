//
//  ValueGridView.swift
//  PlanningPoker
//
//  Created by Simon Roberts on 24/04/2025.
//

import SwiftUI

struct ValueGridView: View {
    let values: [String]
    let onSelect: (String) -> Void

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(values, id: \.self) { value in
                Button(action: {
                    onSelect(value)
                }) {
                    Text(value)
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
    }
}
