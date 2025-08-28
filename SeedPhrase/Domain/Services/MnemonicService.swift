//
//  MnemonicService.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation
import CryptoKit
import CommonCrypto

public protocol MnemonicServiceProtocol {
    func generateEntropy(bits: Int) throws -> Data
    func entropyToMnemonic(entropy: Data, wordlist: [String]) throws -> [String]
    func mnemonicToSeed(mnemonic: String, passphrase: String) -> Data
}

public final class MnemonicService: MnemonicServiceProtocol {
    public init() {}

    // MARK: Entropy
    public func generateEntropy(bits: Int = 128) throws -> Data {
        let allowed = [128, 160, 192, 224, 256]
        guard allowed.contains(bits) else { throw Bip39Error.invalidEntropyLength }
        var data = Data(count: bits / 8)
        let status = data.withUnsafeMutableBytes { ptr in
            SecRandomCopyBytes(kSecRandomDefault, bits / 8, ptr.baseAddress!)
        }
        guard status == errSecSuccess else { throw Bip39Error.entropyGenerationFailed }
        return data
    }

    // MARK: Entropy -> Mnemonic
    public func entropyToMnemonic(entropy: Data, wordlist: [String]) throws -> [String] {
        let entBits = entropy.count * 8
        guard [128,160,192,224,256].contains(entBits) else { throw Bip39Error.invalidEntropyLength }
        precondition(wordlist.count == 2048, "BIP39 English wordlist must contain 2048 words")

        // checksum: first ENT/32 bits of SHA256(entropy)
        let digest = SHA256.hash(data: entropy)
        let checksumLen = entBits / 32

        // concat bits
        var bits = entropy.bits()
        bits.append(contentsOf: Data(digest).bits().prefix(checksumLen))

        // group into 11 bits -> indices
        var words: [String] = []
        words.reserveCapacity((bits.count / 11))
        for i in 0..<(bits.count / 11) {
            let slice = Array(bits[i*11 ..< (i+1)*11])
            let idx = bitsToUInt11(slice)
            guard idx < wordlist.count else { throw Bip39Error.invalidMnemonic }
            words.append(wordlist[idx])
        }
        return words
    }

    // MARK: Mnemonic -> Seed (PBKDF2-HMAC-SHA512)
    public func mnemonicToSeed(mnemonic: String, passphrase: String = "") -> Data {
        // NFKD normalization as per BIP39
        let password = mnemonic.precomposedStringWithCompatibilityMapping
        let saltString = "mnemonic" + passphrase
        let salt = saltString.precomposedStringWithCompatibilityMapping.data(using: .utf8)!
        let passwordData = password.data(using: .utf8)!

        var derived = [UInt8](repeating: 0, count: 64)
        let pwdArray = [UInt8](passwordData)

        let result = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            // password
            pwdArray.withUnsafeBufferPointer { $0.baseAddress }?.withMemoryRebound(to: Int8.self, capacity: pwdArray.count) { $0 },
            pwdArray.count,
            // salt
            [UInt8](salt),
            salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512),
            2048,
            &derived,
            derived.count
        )
        assert(result == kCCSuccess, "PBKDF2 failed: \(result)")
        return Data(derived)
    }
}
