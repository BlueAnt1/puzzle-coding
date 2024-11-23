//
//  SudokuWikiCompatibilityTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
@testable import PuzzleCoding

struct SudokuWikiCompatibilityTests {
    @Test
    func kenKen() throws {
//        let cells = KenKen.veryEasy1
        let raw = "K6B02ff00cr5oaz01jf5r2j00uj5nijb9l75mmj00cr5mmj005n5mmjb8p7b8ln00235mbvbbkb5mbvgvgrgv63guvfb8lnb8wb018r005n5o3v5mmj5mbv00qz0023bfpnb8wbb8ln0023005n"
//        let attempt = KenKen(rawValue: raw)
//        print(attempt)

        let myRaw = try KenKen(cells: KenKen.veryEasy1, version: .versionB).rawValue
        #expect(raw == myRaw)
        let decoded = try #require(KenKen(rawValue: raw))
//        print(Grid(decoded))
        let encoded = decoded.rawValue
        #expect(raw == encoded)

        #expect(decoded == KenKen.veryEasy1)
    }

    @Test(.disabled("Not implemented at SudokuWiki yet"))
    func killerJigsaw() throws {
        let raw = ""
        let decoded = try #require(KillerJigsaw(rawValue: raw))
//        print(Grid(decoded))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
    }

    @Test
    func killerSudoku() throws {
        let raw = "L9B0jdd00ep1jpt1ez50du900ep1g5n08b500ep00ep00ep1ez509w11mvl1ez53bpt2tjl2tjl1rm92zgx00ep00ep31g10g7l1t752tjl0ikx1ez505xt1rm92tjl2tjl00ep1ez51ez500ep1ez500ep1ez54nwx484100ep31g11ez500ep0ff51jbj05xt00ep484100ep2tjl4hld00ep00ep3ci92tjl1qtt2wpd2tjl04cx48411no100ep2tjl2tjl1ez54hld484100ep3dap1ez500ep2tjl0aoh00ep00ep2tjl2tjl2tjl1ez5"
        let myRaw = try KillerSudoku(cells: KillerSudoku.gentleExample1, version: .versionB).rawValue

        #expect(raw == myRaw)
        let decoded = try #require(KillerSudoku(rawValue: raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)

        #expect(decoded == KillerSudoku.gentleExample1)
    }

    @Test
    func jigsawSudoku() throws {
        let raw = "J9B00405i05i0sn0uf0sp0ua1ky1pv05i07a07a0tj0si0um0ui1za1yz0200092fb2ef39i0so1oq1om1ob0012iq2dg2oy3k237o3yb1z61yq2dj2iu2py35w3ie35t4aq4aq3ya5364y22de3he3k240a3y94ci6bn52g4xc5465ja3ja3ze4bu6bl6oi53c4y05uv5uv5j85k66pg6pe6pe52u4qp5ue5j65ue5jb6nm6bo6bp"
        let myRaw = try JigsawSudoku(cells: JigsawSudoku.andrewStuart1Example1, version: .versionB).rawValue
        #expect(raw == myRaw)
        let decoded = try #require(JigsawSudoku(rawValue: raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)

        #expect(decoded == JigsawSudoku.andrewStuart1Example1)
    }

    @Test
    func sudoku() throws {
        // Easiest Sudoku
        var puzzle: Sudoku {
            let cells: [Cell] = """
                    3..967..1
                    .4.3.2.8.
                    .2.....7.
                    .7.....9.
                    ...873...
                    5...1...3
                    ..47.51..
                    9.5...2.7
                    8..621..4
                    """.filter { !$0.isWhitespace }.map { $0.wholeNumberValue ?? 0 }
            .map { Cell(content: $0 == 0 ? .candidates(Set(1...9)) : .clue($0)) }
            return try! Sudoku(cells: cells)
        }

        let raw = "S9B03epep090607epep01ep04ep03ep02ep08epep02epepepepep07epep07epepepepep09epepepep080703epepep05epepep01epepep03epep0407ep0501epep09ep05epepep02ep0708epep060201epep04"
        let decoded = try #require(Sudoku(rawValue: raw))
        #expect(decoded == puzzle)

//        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
    }

    @Test
    func sudokuX() throws {
        let raw = "X9B04epep08ep0502epepepepepepepepepepepep08epep07epepepepepepep02ep0809ep07epepepepepepepep0401ep0503epepepepepepepepepepepep01epepepepepepepepepepepep01epep07epep06"
        let decoded = try #require(SudokuX(rawValue: raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
    }

    @Test
    func windoku() throws {
        let raw = "W9B080603epepepepepepepepepepepepepep04ep04epep05ep0306epep03epep06epep09epep05ep04ep03ep08epep07epep09epep05epep0904ep02epep03ep05epepepepepepepepepepepepepep060205"
        let decoded = try #require(Windoku(rawValue: raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.rawValue
        #expect(raw == encoded)
    }
}
