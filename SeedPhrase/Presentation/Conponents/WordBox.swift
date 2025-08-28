//
//  WordBox.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import SwiftUI

struct WordBox: View {
    let number: Int
    let word: String
    var isPlaceholder: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            Text(number > 0 ? "\(number)" : "")
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(word)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isPlaceholder ? .gray.opacity(0.6) : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(minWidth: 90, minHeight: 56, alignment: .leading)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isPlaceholder ? Color.gray.opacity(0.3) : Color.blue.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
