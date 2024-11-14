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
        // Tim Tang puzzle from SudokuWiki
        let boxShapes = """
                        112222233
                        112444233
                        112444233
                        116444833
                        516678839
                        556777899
                        556678899
                        556777899
                        556678899
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageShapes = """
                        111221121
                        233213321
                        224413112
                        114411332
                        223332211
                        211142122
                        212244122
                        333212133
                        333212233
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageClues = [
            21,  0,  0, 11,  0,  7,  0,  7, 12,
            17, 10,  0,  0, 12, 21,  0,  0,  0,
             0,  0, 19,  0,  0,  0, 11,  0, 14,
             9,  0,  0,  0,  0,  0,  9,  0,  0,
            12,  0, 18,  0,  0, 16,  0,  8,  0,
             0, 17,  0,  0, 22,  0, 16, 19,  0,
             0,  0, 19,  0,  0,  0,  0,  0,  0,
            34,  0,  0,  0, 10, 14,  0, 20,  0,
             0,  0,  0,  0,  0,  0,  0,  0,  0
        ].map(CageContent.clue)

        let content = Array(repeating: CellContent.candidates(Set(1...9)), count: 81)

        let cells = boxShapes.indices.map {
            Cell(box: (boxShapes[$0], 0),
                 cage: (cageShapes[$0], cageClues[$0]),
                 content: content[$0])
        }

        let puzzle = try #require(try KillerJigsaw(cells: cells))
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
