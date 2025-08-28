//
//  Bip39Error.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

public enum Bip39Error: Error, LocalizedError {
    case invalidEntropyLength
    case wordlistMissing
    case invalidMnemonic
    case entropyGenerationFailed

    public var errorDescription: String? {
        switch self {
        case .invalidEntropyLength: return "Invalid entropy length. Allowed: 128, 160, 192, 224, 256 bits."
        case .wordlistMissing:      return "BIP39 English wordlist file is missing."
        case .invalidMnemonic:      return "The mnemonic is invalid or out of range."
        case .entropyGenerationFailed: return "Failed to generate secure random entropy."
        }
    }
}
