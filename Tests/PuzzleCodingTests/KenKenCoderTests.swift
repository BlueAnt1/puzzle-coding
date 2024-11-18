//
//  KenKenCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import Testing
@testable import PuzzleCoding


struct KenKenCoderTests {

    @Test(arguments: KenKen.Version.allCases)
    func coderRoundtrips(version: KenKen.Version) throws {
        var puzzle = KenKen.veryEasy1
        puzzle.version = version
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(KenKen(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
