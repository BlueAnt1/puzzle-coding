//
//  KillerCodingTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

import Testing
@testable import PuzzleCoding

struct KillerCodingTests {
    @Test
    func testKillerSudoku() throws {
        let cageClues = [24,  0,  6,  0, 17,  0,  2, 10,  0,
                          0,  0,  0, 12, 10,  0, 23,  0,  0,
                         16,  8,  0,  0, 10, 20, 18,  0, 23,
                          0,  7, 16,  0,  0,  0,  0,  0,  0,
                          0,  0,  0, 20,  0,  0, 10,  0,  0,
                         19,  6,  7,  0,  0,  0,  0, 12,  0,
                          0, 24,  0, 15,  4,  0,  5,  0, 11,
                          0,  0,  0,  0, 12,  0,  0, 25,  0,
                          0,  0, 13,  0,  0,  0,  0,  0,  0]
        let cageShapes = """
                        112211211
                        112122333
                        231131231
                        212331221
                        212441321
                        121141341
                        133233142
                        133244132
                        131113332
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)

        let coding = KillerCoding(size: .grid9x9, shapeRanges: [1...5])
        let encoded = coding.encode(clues: cageClues, shapes: cageShapes)
        let decoded = try #require(coding.decode(from: encoded))
        #expect(decoded.clues == cageClues)
        #expect(decoded.shapes == [cageShapes])
    }
}
