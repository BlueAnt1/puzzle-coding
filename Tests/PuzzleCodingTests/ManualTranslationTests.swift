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
        let raw = KenKen.veryEasy1.rawValue
//        print(raw)
        let decoded = try #require(KenKen(rawValue: raw))
        //        let grid = Grid(decoded.puzzle)
        //        print(grid.cellContent)
        //        print(grid.cage)
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == KenKen.veryEasy1)
    }

    @Test
    func kenKenSmall3() throws {
        let raw = KenKen.small3.rawValue
//        print(raw)
        let decoded = try #require(KenKen(rawValue: raw))
//        let grid = Grid(decoded)
//        print(grid.cellContent)
//        print(grid.cage)
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == KenKen.small3)
    }

    @Test
    func kenKenSmall4() throws {
        let raw = KenKen.small4.rawValue
//        print(raw)
        let decoded = try #require(KenKen(rawValue: raw))
//        let grid = Grid(decoded)
//        print(grid.cellContent)
//        print(grid.cage)
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == KenKen.small4)
    }

    @Test
    func killerSudoku() throws {
        let raw = KillerSudoku.gentleExample1.rawValue
        let decoded = try #require(KillerSudoku(rawValue: raw))
        //        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == KillerSudoku.gentleExample1)
    }

    @Test
    func jigsawSudoku() throws {
        let raw = JigsawSudoku.andrewStuart1Example1.rawValue
        let decoded = try #require(JigsawSudoku(rawValue: raw))
        //        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == JigsawSudoku.andrewStuart1Example1)
    }

    @Test
    func str8ts() throws {
        let raw = Str8ts.easy1.rawValue
        let decoded = try #require(Str8ts(rawValue: raw))
        let grid = Grid(decoded)
//        print(raw)
//        print(grid.group)
//        print(grid.cellContent)
        let encoded = decoded.rawValue
        #expect(raw == encoded)
        #expect(decoded == Str8ts.easy1)
    }
}
