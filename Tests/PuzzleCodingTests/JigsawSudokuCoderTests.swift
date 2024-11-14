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
        let boxShapes = "111112222113345522133444552134444452637777752633777559638878859668888899666699999".map(\.wholeNumberValue!)
        let content: [CellContent?] = "9..21.....6......1.8......95...34..7..31.29..2..78...47......4.8......1.....96..2"
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
        let cells = boxShapes.indices.map { Cell(box: (boxShapes[$0], 0), content: content[$0]) }
        let puzzle = try JigsawSudoku(cells: cells)
        let rawPuzzle = puzzle.encode(using: version)

        let decoded = try #require(JigsawSudoku.decode(rawPuzzle))

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

