//
//  KillerSudokuCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import Testing
@testable import PuzzleCoding


struct KillerSudokuCoderTests {

    @Test(arguments: KillerSudoku.Version.allCases)
    func coderRoundtrips(version: KillerSudoku.Version) throws {
        let puzzle = try KillerSudoku(cells: KillerSudoku.gentleExample1, version: version)
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(KillerSudoku(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
