//
//  KillerJigsaw+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension Str8ts {
    static var easy1: Str8ts {
        let baseContent: [Cell.Content?] = [
            .blackClue(6), nil, .clue(3), .blackEmpty, .blackEmpty, nil, nil, .blackEmpty, .blackEmpty,
            .clue(4), .clue(1), nil, .clue(3), .blackEmpty, nil, .clue(8), nil, .clue(6),
            nil, nil, .blackEmpty, nil, nil, .blackEmpty, nil, nil, nil,
            nil, nil, nil, .blackClue(2), nil, nil, nil, .clue(7), .blackEmpty,
            .blackEmpty, .blackClue(9), nil, nil, .clue(6), nil, nil, .blackEmpty, .blackEmpty,
            .blackEmpty, nil, nil, nil, nil, .blackEmpty, nil, nil, nil,
            nil, nil, .clue(8), .blackEmpty, .clue(4), nil, .blackEmpty, .clue(6), nil,
            nil, nil, .clue(9), nil, .blackClue(1), .clue(2), nil, nil, nil,
            .blackEmpty, .blackEmpty, .clue(5), .clue(6), .blackEmpty, .blackClue(4), .clue(2), nil, .blackEmpty
        ]
        let content: [Cell.Content] = baseContent.map { $0 == nil ? .candidates(Set(1...9)) : $0! }

        let cells = content.map { Cell(content: $0) }

        return try! Str8ts(cells: cells)
    }
}
