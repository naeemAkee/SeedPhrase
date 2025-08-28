//
//  SeedOnboardingViewModel.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

@MainActor
final class SeedOnboardingViewModel: ObservableObject {
    @Published var seedPhrase: SeedPhraseUIModel?
    @Published var userSelectedWords: [String] = []
    @Published var verificationResult: Bool? = nil

    private let generateSeedUseCase: GenerateSeedPhraseUseCaseProtocol
    private let verifySeedUseCase: VerifySeedPhraseUseCaseProtocol

    init(generateSeedUseCase: GenerateSeedPhraseUseCaseProtocol,
         verifySeedUseCase: VerifySeedPhraseUseCaseProtocol) {
        self.generateSeedUseCase = generateSeedUseCase
        self.verifySeedUseCase = verifySeedUseCase
    }

    func generateSeed(bits: Int = 128) {
        do {
            let seed = try generateSeedUseCase.execute(bits: bits)
            self.seedPhrase = SeedPhraseUIModel(words: seed.words)
        } catch {
            print("❌ Error generating seed:", error.localizedDescription)
        }
    }

    func verify() {
        guard let original = seedPhrase?.words else { return }
        verificationResult = verifySeedUseCase.execute(userInput: userSelectedWords, original: original)
    }

    func resetVerification() {
        userSelectedWords.removeAll()
        verificationResult = nil
    }
}
