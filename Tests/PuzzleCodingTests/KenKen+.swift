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
        let cageContent: [CageInfo.Content?] = [
            .clue(24), .operator(.multiply), .clue(20), .clue(15), .clue(48), .clue(8),
            .clue(12), .clue(10), .operator(.multiply), .operator(.multiply), .operator(.multiply), .operator(.add),
            .operator(.multiply), .operator(.add), nil, nil, nil, .clue(30),
            nil, .clue(6), .operator(.multiply), nil, nil, .operator(.multiply),
            .clue(12), .operator(.add), .clue(18), .operator(.multiply), nil, .clue(7),
            nil, .clue(72), .operator(.multiply), nil, nil, .operator(.add)
        ]

        let cells = cageShapes.indices.map {
            Cell(cage: CageInfo(cage: cageShapes[$0], content: cageContent[$0]),
                 content: .candidates(Set(1...6)))
        }

        return try! KenKen(cells: cells)
    }

    static var small3: KenKen {
        let cageShapes = """
                        122
                        133
                        331
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageContent: [CageInfo.Content?] = [
            .clue(1), .clue(2), .operator(.divide),
            .operator(.subtract), .clue(6), .operator(.multiply),
            nil, nil, .clue(3)
        ]

        let cells = cageShapes.indices.map {
            Cell(cage: CageInfo(cage: cageShapes[$0], content: cageContent[$0]),
                 content: .candidates(Set(1...3)))
        }

        return try! KenKen(cells: cells)
    }

    static var small4: KenKen {
        let cageShapes = """
                        1221
                        1341
                        2344
                        2111
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let cageContent: [CageInfo.Content?] = [
            .clue(1), .clue(1), .operator(.subtract), .clue(3),
            .operator(.subtract), .clue(2), .clue(48), .operator(.add),
            .clue(1), .operator(.divide), .operator(.multiply), nil,
            .operator(.subtract), .clue(8), .operator(.add), nil
        ]

        let cells = cageShapes.indices.map {
            Cell(cage: CageInfo(cage: cageShapes[$0], content: cageContent[$0]),
                 content: .candidates(Set(1...4)))
        }

        return try! KenKen(cells: cells)
    }
}
