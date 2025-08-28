//
//  VerifySeedPhraseUseCase.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

public protocol VerifySeedPhraseUseCaseProtocol {
    func execute(userInput: [String], original: [String]) -> Bool
}

public final class VerifySeedPhraseUseCase: VerifySeedPhraseUseCaseProtocol {
    public init() {}

    public func execute(userInput: [String], original: [String]) -> Bool {
        return userInput == original
    }
}
