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
        let encoded = coding.encode(clues: cageClues, shapes: [cageShapes])
        let decoded = try #require(coding.decode(from: encoded))
        #expect(decoded.clues == cageClues)
        #expect(decoded.shapes == [cageShapes])
    }

    @Test
    func testKillerJigsaw() throws {
        let cageShapes = """
                        112122211
                        122133122
                        333224132
                        131334133
                        111311221
                        221344431
                        244414234
                        112111244
                        112233211
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let boxShapes = """
                        111222233
                        111222233
                        114452333
                        144455633
                        444555666
                        774556669
                        777856699
                        778888999
                        778888999
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageClues = [
            21,  0,  0, 11,  0,  7,  0,  7, 12,
            17, 10,  0,  0, 12, 21,  0,  0,  0,
             0,  0, 19,  0,  0,  0, 11,  0, 14,
             9,  0,  0,  0,  0,  0,  9,  0,  0,
            12,  0, 18,  0,  0, 16,  0,  8,  0,
             0, 17,  0,  0, 22,  0, 16, 19,  0,
             0,  0, 19,  0,  0,  0,  0,  0,  0,
            34,  0,  0,  0, 10, 14,  0, 20,  0,
             0,  0,  0,  0,  0,  0,  0,  0,  0
        ]

        let coding = KillerCoding(size: .grid9x9, shapeRanges: [1...5, 1...9])
        let encoded = coding.encode(clues: cageClues, shapes: [cageShapes, boxShapes])
        let decoded = try #require(coding.decode(from: encoded))
        #expect(decoded.clues == cageClues)
        #expect(decoded.shapes[0] == cageShapes)
        #expect(decoded.shapes[1] == boxShapes)

    }
}
