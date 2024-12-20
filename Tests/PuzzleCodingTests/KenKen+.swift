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
        let operators: [Clue.Operator?] = [
            .multiply(24), nil,           .multiply(20), .multiply(15), .multiply(48), .add(8),
            .multiply(12), .add(10),      nil,           nil,           nil,            nil,
            nil,           nil,           nil,           nil,           nil,            .multiply(30),
            nil,           .multiply(6),  nil,           nil,           nil,            nil,
            .add(12),      nil,           .multiply(18), nil,           nil,           .add(7),
            nil,           .multiply(72), nil,           nil,           nil,           nil
        ]

        let cells = zip(cageShapes, operators).map { cage, op in
            Cell(clue: .cage(id: cage, operator: op), content: .candidates(Set(1...6)))
        }

        return try! KenKen(cells: cells)
    }

    static var small3: KenKen {
        let cageShapes = """
                        112
                        232
                        231
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let operators: [Clue.Operator?] = [
            .subtract(2), nil, .add(3),
            .subtract(1), .divide(2), nil,
            nil, nil, .add(3)
        ]

        let cells = zip(cageShapes, operators).map { cage, op in
            Cell(clue: .cage(id: cage, operator: op),
                 content: .candidates(Set(1...3)))
        }

        return try! KenKen(cells: cells)
    }

    static var small4: KenKen {
        let cageShapes = """
                        1212
                        1312
                        2331
                        2111
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let operators: [Clue.Operator?] = [
            .subtract(2), .add(2),      .subtract(3), .divide(2),
            nil,          .multiply(6), nil,          nil,
            .divide(2),   nil,          nil,         .add(11),
            nil,          nil,          nil,          nil
        ]

        let cells = zip(cageShapes, operators).map { cage, op in
            Cell(clue: .cage(id: cage, operator: op),
                 content: .candidates(Set(1...4)))
        }

        return try! KenKen(cells: cells)
    }
}
