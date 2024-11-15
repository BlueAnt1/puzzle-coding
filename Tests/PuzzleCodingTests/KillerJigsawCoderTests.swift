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
        let puzzle = KillerJigsaw.timTang
        let rawPuzzle = puzzle.encode(using: version)

        let decoded = try #require(KillerJigsaw.decode(rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version) (Tim Tang)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
