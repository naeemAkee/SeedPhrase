//
//  Bits.swift
//  SeedPhrase
//
//  Created by Muhammad Naeem Akram on 28/08/2025.
//

import Foundation

// MARK: - Data -> Bits
extension Data {
    /// Returns bits as [0/1] (MSB first)
    func bits() -> [UInt8] {
        var arr = [UInt8]()
        arr.reserveCapacity(self.count * 8)
        for byte in self {
            for i in (0..<8).reversed() {
                arr.append((byte >> i) & 0x01)
            }
        }
        return arr
    }
}

// MARK: - 11-bit to Int
func bitsToUInt11(_ bits: [UInt8]) -> Int {
    var value = 0
    for b in bits {
        value = (value << 1) | Int(b)
    }
    return value
}
