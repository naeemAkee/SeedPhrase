//
//  SeedPhrase.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

public struct SeedPhrase: Equatable {
    public let words: [String]
    public let entropy: Data
    public let seed: Data

    public init(words: [String], entropy: Data, seed: Data) {
        self.words = words
        self.entropy = entropy
        self.seed = seed
    }
}
