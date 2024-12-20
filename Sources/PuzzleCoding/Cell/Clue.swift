//
//  Clue.swift
//  puzzle-conding
//
//  Created by Quintin May on 12/1/24.
//

public typealias CageID = Int

public enum Clue: Hashable, Sendable {
    case solution(Int)
    case cage(id: CageID, operator: Operator?)
    /// A empty black cell.
    case blackEmpty
    /// A black puzzle clue (Str8ts).
    case blackClue(Int)

    public enum Operator: Hashable, Codable, CustomStringConvertible, Sendable {
        case add(Int)
        case subtract(Int)
        case multiply(Int)
        case divide(Int)

        public var symbol: Character {
            switch self {
            case .add: "+"
            case .subtract: "−"
            case .multiply: "×"
            case .divide: "÷"
            }
        }

        var value: Int {
            switch self {
            case .add: 1
            case .subtract: 2
            case .multiply: 3
            case .divide: 4
            }
        }

        public var operand: Int {
            switch self {
            case .add(let operand), .subtract(let operand),
                    .multiply(let operand), .divide(let operand): operand
            }
        }

        public var description: String { "\(operand)\(symbol)" }
    }

    var solution: Int? {
        if case .solution(let solution) = self {
            solution
        } else {
            nil
        }
    }

    var cageID: CageID? {
        if case .cage(let id, _) = self {
            id
        } else {
            nil
        }
    }
}
