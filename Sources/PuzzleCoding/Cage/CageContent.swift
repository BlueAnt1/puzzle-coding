//
//  CageContent.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

public enum CageContent: Equatable, Sendable {
    case clue(Int)
    case `operator`(Operator)

    public enum Operator: Int, CaseIterable, CustomStringConvertible, Sendable {
        case add = 1, subtract, multiply, divide

        public var description: String {
            switch self {
            case .add: "+"
            case .subtract: "−"
            case .multiply: "×"
            case .divide: "÷"
            }
        }
    }

    var clue: Int? {
        if case .clue(let clue) = self { clue } else { nil }
    }

    var `operator`: Operator? {
        if case .operator(let op) = self { op } else { nil }
    }
}
