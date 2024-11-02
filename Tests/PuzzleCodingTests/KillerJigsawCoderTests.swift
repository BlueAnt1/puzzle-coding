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
        let cageShapes = """
                        112122211
                        122133122
                        333224132
                        131334133
                        111311221
                        221344431
                        244414234
                        112111244
                        112233211
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let boxShapes = """
                        111222233
                        111222233
                        114452333
                        144455633
                        444555666
                        774556669
                        777856699
                        778888999
                        778888999
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
        ]
        let content = Array(repeating: CellContent.candidates(Set(1...9)), count: 81)

        var grid = Grid(size: .grid9x9)
        grid.indices.forEach { grid[$0] = content[$0] }

        let puzzle = KillerJigsaw(cageClues: cageClues, cageShapes: cageShapes, boxShapes: boxShapes, grid: grid)
        let rawPuzzle = puzzle.encode(to: version)

        let decoded = try #require(KillerJigsaw.decode(from: rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle.cageClues == cageClues)
        #expect(decoded.puzzle.cageShapes == cageShapes)
        #expect(decoded.puzzle.boxShapes == boxShapes)
        #expect(decoded.puzzle.grid == grid)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            Killer Jigsaw \(version) \(grid.size)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
