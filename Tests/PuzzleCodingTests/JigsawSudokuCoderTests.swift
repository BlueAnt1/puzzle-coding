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
        let content: [Cell.Content?] = "9..21.....6......1.8......95...34..7..31.29..2..78...47......4.8......1.....96..2"
            .map { character in
                switch character.wholeNumberValue {
                case let value?: .clue(value)
                case nil:
                    switch (0...2).randomElement()! {
                    case 0: .solution((1...9).randomElement()!)
                    case 1: .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
                    default: nil
                    }
                }
            }
        let cells = shapes.indices.map { Cell(group: shapes[$0], content: content[$0]) }
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
        #expect (puzzle.map { $0.content } == myPuzzle.map { $0.content })   // group, content
        let shapes = Shapes(puzzle.map(\.group!))
        let myShapes = Shapes(myPuzzle.map(\.group!))
        for (shape1, shape2) in zip(shapes, myShapes) {
            #expect(shape1.shape == shape2.shape)
            #expect(shape1.color == shape2.color)
        }
        print(myPuzzle.rawValue)
    }
}

