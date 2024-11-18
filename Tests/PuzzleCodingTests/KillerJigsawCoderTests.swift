//
//  KillerSudokuCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import Testing
@testable import PuzzleCoding

struct KillerJigsawCoderTests {

    @Test(arguments: KillerJigsaw.Version.allCases)
    func coderRoundtrips(version: KillerJigsaw.Version) throws {
        let puzzle = try KillerJigsaw(cells: KillerJigsaw.timTang, version: version)
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(KillerJigsaw(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version) (Tim Tang)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
