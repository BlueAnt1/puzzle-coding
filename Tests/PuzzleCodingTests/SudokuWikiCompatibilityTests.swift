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
        let raw = "K6B04sr00nf5qa3030r5vt701mz5op7bakr5mx700nf5mx700975mx7b8srb8ln00235mbvbeiz5mbvgw23gvgrguvfb8lnb96z02ff00975pvv5mx75mbv01fv0023bmtnb96zb8ln00230097"
        let myRaw = KenKen.veryEasy1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(KenKen.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == KenKen.veryEasy1)
    }

    @Test(.disabled("Not implemented at SudokuWiki yet"))
    func killerJigsaw() throws {
        let raw = ""
        let decoded = try #require(KillerJigsaw.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func killerSudoku() throws {
        let raw = "L9B0jdd00ep1jpt1ez50du900ep1g5n08b500ep00ep00ep1ez509w11mvl1ez53bpt2tjl2tjl1rm92zgx00ep00ep31g10g7l1t752tjl0ikx1ez505xt1rm92tjl2tjl00ep1ez51ez500ep1ez500ep1ez54nwx484100ep31g11ez500ep0ff51jbj05xt00ep484100ep2tjl4hld00ep00ep3ci92tjl1qtt2wpd2tjl04cx48411no100ep2tjl2tjl1ez54hld484100ep3dap1ez500ep2tjl0aoh00ep00ep2tjl2tjl2tjl1ez5"
        let myRaw = KillerSudoku.gentleExample1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(KillerSudoku.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == KillerSudoku.gentleExample1)
    }

    @Test
    func jigsawSudoku() throws {
        let raw = "J9B0040ep0ep0sn1750sp1751ky1zl0ep0ep0ep1750si1751751zl1zl0ep0092s12s13kh0so1zl1zl1zl0012s12dg2s13kh3kh3yb1zl1zl2dj2s12s135w3kh35t4cx4cx3ya55d55d2de3kh3kh4cx3y94cx6bn55d55d55d5ja3kh4cx4cx6bl6q955d55d5xt5xt5j85xt6q96q96q955d4qp5xt5j65xt5jb6q96bo6bp"
        let myRaw = JigsawSudoku.andrewStuart1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(JigsawSudoku.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == JigsawSudoku.andrewStuart1)
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
        let decoded = try #require(Sudoku.decode(raw))
        #expect(decoded.puzzle == puzzle)

//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func sudokuX() throws {
        let raw = "X9B04epep08ep0502epepepepepepepepepepepep08epep07epepepepepepep02ep0809ep07epepepepepepepep0401ep0503epepepepepepepepepepepep01epepepepepepepepepepepep01epep07epep06"
        let decoded = try #require(SudokuX.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func windoku() throws {
        let raw = "W9B080603epepepepepepepepepepepepepep04ep04epep05ep0306epep03epep06epep09epep05ep04ep03ep08epep07epep09epep05epep0904ep02epep03ep05epepepepepepepepepepepepepep060205"
        let decoded = try #require(Windoku.decode(raw))
//        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }
}
