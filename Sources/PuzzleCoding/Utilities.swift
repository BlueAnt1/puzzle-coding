//
//  Utilities.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

extension FixedWidthInteger {
    /// A set representing the `1` bits in an integer. The least significant bit is `1`.
    ///
    /// The number `5` whose binary representation is `101` is represented as ``[3, 1]``. Bit `1` and bit `3` are set.
    /// - SeeAlso: ``Collection/bitValue``
    var oneBits: Set<Int> {
        var ones = Set<Int>()
        var bit = 1
        var value = self
        while value > 0 {
            if value & 0b1 == 1 { ones.insert(bit) }
            bit += 1
            value &>>= 1
        }
        return ones
    }
}

extension Collection<Int> {
    /// The integer value represented by the bits in the collection.
    ///
    /// The set `[4, 3, 1]` represents the binary value `1101` or `13`.
    /// - SeeAlso: ``FixedWidthInteger/oneBits``
    var bitValue: Int { reduce(0) { $0 | (1 << ($1 - 1)) }}
}

enum PuzzleCoding {
    /// The numeric radix used for puzzle coding.
    static var radix: Int { 36 }
}
