//
//  JigsawSudokuCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

import Testing
@testable import PuzzleCoding

struct JigsawSudokuCoderTests {

    @Test(arguments: JigsawSudoku.Version.allCases)
    func coderRoundtrips(version: JigsawSudoku.Version) throws {
        let shapes = "111112222113345522133444552134444452637777752633777559638878859668888899666699999".map(\.wholeNumberValue!)
        let clues = "900210000060000001080000009500034007003102900200780004700000040800000010000096002".map(\.wholeNumberValue!).map { $0 == 0 ? nil : Clue.solution($0) }
        let progress: [Progress?] = clues.map { clue in
            if clue == nil {
                switch (0...2).randomElement()! {
                case 0: .guess((1...9).randomElement()!)
                case 1: .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
                default: nil
                }
            } else {
                nil
            }
        }
        let cells = shapes.indices.map { Cell(region: shapes[$0], progress: progress[$0]) }
        let puzzle = try JigsawSudoku(cells: cells, version: version)
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(JigsawSudoku(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test
    func doubleMirror() throws {
        let raw = "J9B0ep0ep0ep0ep3kh1751751751750ep0060ep3kh3kh3kh1750sn1750ep55d36135t3kh35x35u5xt1750ep4qv55d6q96q96q95xt5xt0sk4qr55d4qw6q96q96q95j95xt5ja2dh55d55d6q96bn6q95xt5j61zl2s155d3yb3yf4cx3yc3ye5xt1zl2s12de2s14cx4cx4cx1zl1kz1zl2s12s12s12s14cx1ky1zl1zl1zl"
        let puzzle = try #require(JigsawSudoku(rawValue: raw))
        let myPuzzle = JigsawSudoku.doubleMirror
        #expect (puzzle.map { $0.progress } == myPuzzle.map { $0.progress })   // group, content
        let shapes = Shapes(puzzle.map(\.region!))
        let myShapes = Shapes(myPuzzle.map(\.region!))
        for (shape1, shape2) in zip(shapes, myShapes) {
            #expect(shape1.shape == shape2.shape)
            #expect(shape1.color == shape2.color)
        }
        print(myPuzzle.rawValue)
    }
}

