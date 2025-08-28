//
//  GenerateSeedPhraseUseCase.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

public protocol GenerateSeedPhraseUseCaseProtocol {
    func execute(bits: Int) throws -> SeedPhrase
}

public final class GenerateSeedPhraseUseCase: GenerateSeedPhraseUseCaseProtocol {
    private let repo: WordlistRepository
    private let service: MnemonicServiceProtocol

    public init(repo: WordlistRepository, service: MnemonicServiceProtocol) {
        self.repo = repo
        self.service = service
    }

    public func execute(bits: Int) throws -> SeedPhrase {
        let entropy = try service.generateEntropy(bits: bits)
        let wordlist = try repo.loadWordlist()
        let words = try service.entropyToMnemonic(entropy: entropy, wordlist: wordlist)
        let seed = service.mnemonicToSeed(mnemonic: words.joined(separator: " "), passphrase: "")
        return SeedPhrase(words: words, entropy: entropy, seed: seed)
    }
}
