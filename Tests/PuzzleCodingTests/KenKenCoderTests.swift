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
        let puzzle = KenKen.veryEasy1
        let rawPuzzle = puzzle.encode(using: version)

        let decoded = try #require(KenKen.decode(rawPuzzle))

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
