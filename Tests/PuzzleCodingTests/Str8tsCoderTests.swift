//
//  Str8tsCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

import Testing
@testable import PuzzleCoding

struct Str8tsCoderTests {

    @Test(arguments: Str8ts.Version.allCases)
    func coderRoundtrips(version: Str8ts.Version) throws {
        let content: [CellContent?] = "006700400000004005090001000015042009000028060000300000001050003670000000000007050".map {
            let number = $0.wholeNumberValue ?? 0
            return number == 0
            ? Bool.random() ? .solution((1...9).randomElement()!) : .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
            : .clue(number)
        }
        var grid = Grid(size: .grid9x9)
        grid.indices.forEach { grid[$0] = content[$0] }

        let colors = "100011001100010001011000110000000100100010001001000000011000110100010001100110001".map(\.wholeNumberValue!)
        let puzzle = Str8ts(colors: colors, grid: grid)
        let rawPuzzle = puzzle.encode(to: version)

        let decoded = try #require(Str8ts.decode(from: rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle.colors == colors)
        #expect(decoded.puzzle.grid == grid)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}
