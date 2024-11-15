//
//  KenKen+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension KenKen {
    // This is the actual data, manually coded, for Very Easy 1
    static var veryEasy1: KenKen {
        let cageShapes = """
                        112121
                        232121
                        233123
                        244433
                        112221
                        133311
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageContent: [CageContent?] = [
            .clue(24), .operator(.multiply), .clue(20), .clue(15), .clue(48), .clue(8),
            .clue(12), .clue(10), .operator(.multiply), .operator(.multiply), .operator(.multiply), .operator(.add),
            .operator(.multiply), .operator(.add), nil, nil, nil, .clue(30),
            nil, .clue(6), .operator(.multiply), nil, .operator(.multiply), nil,
            .clue(12), .operator(.add), .clue(18), .operator(.multiply), nil, .clue(7),
            nil, .clue(72), .operator(.multiply), nil, .operator(.add), nil
        ]

        let cells = cageShapes.indices.map {
            Cell(cage: (shape: cageShapes[$0], content: cageContent[$0]),
                 content: .candidates(Set(1...6)))
        }

        return try! KenKen(cells: cells)
    }
}
