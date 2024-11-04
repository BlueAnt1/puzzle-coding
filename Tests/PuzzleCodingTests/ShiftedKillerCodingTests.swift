//
//  ShiftedKillerCodingTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
@testable import PuzzleCoding

struct ShiftedKillerCodingTests {
    @Test
    func oneCodes() throws {
        let size = Size.grid9x9
        let coding = ShiftedKillerCoding(size: size, shapeRanges: [1...5])
        let encoded = coding.encode(clues: Array(repeating: 0, count: size.gridCellCount),
                                    shapes: [Array(repeating: 1, count: size.gridCellCount)])
        #expect(encoded.allSatisfy { $0 == 0 })
    }

    @Test
    func twoCodes() throws {
        let size = Size.grid9x9
        let coding = ShiftedKillerCoding(size: size, shapeRanges: [1...5])
        let clues = Array(repeating: 0, count: size.gridCellCount)
        let shapes = Array(repeating: 2, count: size.gridCellCount)
        let encoded = coding.encode(clues: clues,
                                    shapes: [shapes])
        #expect(encoded.allSatisfy { $0 == 1 })
    }
}
