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
        let puzzle = KillerSudoku.gentleExample1
        let rawPuzzle = puzzle.encode(using: version)

        let decoded = try #require(KillerSudoku.decode(rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
