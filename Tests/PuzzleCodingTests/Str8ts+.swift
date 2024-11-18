//
//  KillerJigsaw+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension Str8ts {
    static var easy1: Str8ts {
        let shapes = """
                    100110011
                    000010000
                    001001000
                    000100001
                    110000011
                    100001000
                    000100100
                    000010000
                    110011001
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let content: [Int] = """
                603000000
                410300806
                000000000
                000200070
                090060000
                000000000
                008040060
                009012000
                005604200
                """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let filledContent: [Cell.Content?] = shapes.indices
            .map {
                if content[$0] == 0 && shapes[$0] == 0 {
                    .candidates(Set(1...9))
                } else if content[$0] == 0 {
                    nil
                } else {
                    .clue(content[$0])
                }
            }
        let cells = shapes.indices.map {
            Cell(group: shapes[$0],
                 content: filledContent[$0])
        }

        return try! Str8ts(cells: cells)
    }
}
