//
//  KillerCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import Testing
@testable import PuzzleCoding

struct KillerCoderTests {

    @Test(arguments: Killer.Version.allCases)
    func coderRoundtrips(version: Killer.Version) throws {
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
        let cageClues = [24,  0,  6,  0, 17,  0,  2, 10,  0,
                          0,  0,  0, 12, 10,  0, 23,  0,  0,
                         16,  8,  0,  0, 10, 20, 18,  0, 23,
                          0,  7, 16,  0,  0,  0,  0,  0,  0,
                          0,  0,  0, 20,  0,  0, 10,  0,  0,
                         19,  6,  7,  0,  0,  0,  0, 12,  0,
                          0, 24,  0, 15,  4,  0,  5,  0, 11,
                          0,  0,  0,  0, 12,  0,  0, 25,  0,
                          0,  0, 13,  0,  0,  0,  0,  0,  0]
        let clues = "000000200000000000080000000000000000000000000060000000000000000000000000000000000"
            .map(\.wholeNumberValue!)
            .map { $0 == 0 ? nil : CellContent.clue($0) }
        let grid = try #require(Grid(size: .grid9x9, content: clues))
        let puzzle = Killer(cageClues: cageClues, cageShapes: cageShapes, grid: grid)
        let rawPuzzle = puzzle.encode(to: version)

        let decoded = try #require(Killer.decode(from: rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle.cageClues == cageClues)
        #expect(decoded.puzzle.cageShapes == cageShapes)
        #expect(decoded.puzzle.grid == grid)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            Killer \(version) \(grid.size)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}

/*
 112211211112122333231131231212331221212441321121141341133233142133244132131113332,240006001700021000000000121000230000160800001020180023000716000000000000000000200000100000190607000000001200002400150400050011000000001200002500000013000000000000
 */
