//
//  CageCell.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

public struct CageCell: Equatable, Sendable {
    public var cage: Int
    public var content: Content?

    public enum Content: Equatable, Sendable {
        case clue(Int)
        case `operator`(Operator)

        public enum Operator: Int, Sendable {
            case add = 1, subtract, multiply, divide

            static var maxValue: Int { Self.divide.rawValue }
        }
    }
}

extension CageCell.Content: CustomStringConvertible {
    public var description: String {
        switch self {
        case .clue(let clue): "\(clue)"
        case .operator(let `operator`): "\(`operator`)"
        }
    }
}

extension CageCell.Content.Operator: CustomStringConvertible {
    public var description: String {
        switch self {
        case .add: "+"
        case .subtract: "−"
        case .multiply: "×"
        case .divide: "÷"
        }
    }
}

