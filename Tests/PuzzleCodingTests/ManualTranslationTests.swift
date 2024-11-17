//
//  ManualTranslationTests.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/17/24.
//

import Testing
@testable import PuzzleCoding

struct ManualTranslationTests {
    @Test
    func kenKen() throws {
        let raw = KenKen.veryEasy1.encode(using: .versionB)
        let decoded = try #require(KenKen.decode(raw))
//        let grid = Grid(decoded.puzzle)
//        print(grid.cellContent)
//        print(grid.cage)
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
        #expect(decoded.puzzle == KenKen.veryEasy1)
    }

    @Test
    func killerSudoku() throws {
        let raw = KillerSudoku.gentleExample1.encode(using: .versionB)
        let decoded = try #require(KillerSudoku.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
        #expect(decoded.puzzle == KillerSudoku.gentleExample1)
    }

    @Test
    func jigsawSudoku() throws {
        let raw = JigsawSudoku.andrewStuart1.encode(using: .versionB)
        let decoded = try #require(JigsawSudoku.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
        #expect(decoded.puzzle == JigsawSudoku.andrewStuart1)
    }
}
