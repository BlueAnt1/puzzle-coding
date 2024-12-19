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
        let colors = "100011001100010001011000110000000100100010001001000000011000110100010001100110001".map(\.wholeNumberValue!)
        let content: [Cell.Content?] = "006700400000004005090001000015042009000028060000300000001050003670000000000007050".map {
            let number = $0.wholeNumberValue ?? 0
            return number == 0
            ? Bool.random() ? .guess((1...9).randomElement()!) : .candidates(Set((1...9).randomSample(count: (1...9).randomElement()!)))
            : .clue(number)
        }
        let cells = colors.indices.map {
            Cell(group: colors[$0],
                 content: content[$0])
        }

        let puzzle = try #require(try Str8ts(cells: cells, version: version))
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(Str8ts(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

//    @Test
//    func sizes() {
//        for size in Size.allCases {
//            let transform = Str8tsCellContentTransform(size: size)
//            let _ = transform.encode(nil)
//        }
//    }
}

