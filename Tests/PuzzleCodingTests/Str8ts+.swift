//
//  KillerJigsaw+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension Str8ts {
    static var easy1: Str8ts {
        let clues: [Clue?] = [
            .black(6), nil, .solution(3), .blackEmpty, .blackEmpty, nil, nil, .blackEmpty, .blackEmpty,
            .solution(4), .solution(1), nil, .solution(3), .blackEmpty, nil, .solution(8), nil, .solution(6),
            nil, nil, .blackEmpty, nil, nil, .blackEmpty, nil, nil, nil,
            nil, nil, nil, .black(2), nil, nil, nil, .solution(7), .blackEmpty,
            .blackEmpty, .black(9), nil, nil, .solution(6), nil, nil, .blackEmpty, .blackEmpty,
            .blackEmpty, nil, nil, nil, nil, .blackEmpty, nil, nil, nil,
            nil, nil, .solution(8), .blackEmpty, .solution(4), nil, .blackEmpty, .solution(6), nil,
            nil, nil, .solution(9), nil, .black(1), .solution(2), nil, nil, nil,
            .blackEmpty, .blackEmpty, .solution(5), .solution(6), .blackEmpty, .black(4), .solution(2), nil, .blackEmpty
        ]
        let cells: [Cell] = clues.map {
            $0 == nil
            ? Cell(progress: .candidates(Set(1...9)))
            : Cell(clue: $0)
        }

        return try! Str8ts(cells: cells)
    }
}
