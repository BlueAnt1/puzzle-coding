//
//  JigsawCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

import Testing
@testable import PuzzleCoding

struct JigsawCoderTests {

    @Test(arguments: Jigsaw.Version.allCases)
    func coderRoundtrips(version: Jigsaw.Version) throws {
        let content: [CellContent?] = "9..21.....6......1.8......95...34..7..31.29..2..78...47......4.8......1.....96..2".map {
            let number = $0.wholeNumberValue ?? 0
            return number == 0
            ? Bool.random() ? .solution((1...9).randomElement()!) : .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
            : .clue(number)
        }
        let grid = try #require(Grid(size: .grid9x9, content: content))
        let boxes = "111112222113345522133444552134444452637777752633777559638878859668888899666699999".map(\.wholeNumberValue!)
        let puzzle = Jigsaw(boxes: boxes, grid: grid)
        let rawPuzzle = puzzle.encode(to: version)

        let decoded = try #require(Jigsaw.decode(from: rawPuzzle))

        #expect(decoded.version == version)
        #expect(decoded.puzzle.boxes == boxes)
        #expect(decoded.puzzle.grid == grid)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            Jigsaw \(version) \(grid.size)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }
}

