//
//  LocalWordlistRepository.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

public protocol WordlistRepository {
    func loadWordlist() throws -> [String]
}

public final class LocalWordlistRepository: WordlistRepository {
    public init() {}

    public func loadWordlist() throws -> [String] {
        guard let url = Bundle.main.url(forResource: "bip39_english", withExtension: "txt") else {
            throw Bip39Error.wordlistMissing
        }
        let text = try String(contentsOf: url, encoding: .utf8)
        return text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
