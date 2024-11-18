//
//  CageInfo.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

/// Cage related information about a cell.
///
/// >Important: Be sure you understand how to store information for <doc:Cages> and <doc:Shapes>.
public struct CageInfo: Equatable, Sendable {
    /// The cage containing the cell.
    public var cage: Int
    /// The cage content such as a clue or operator.
    public var content: Content?

    /// The content a cell stores relating to the cage.
    public enum Content: Equatable, Sendable {
        /// A clue.
        case clue(Int)
        /// An operator.
        case `operator`(Operator)

        /// A cage operator
        public enum Operator: Int, Sendable {
            case add = 1, subtract, multiply, divide

            static var maxValue: Int { Self.divide.rawValue }
        }
    }
}

extension CageInfo.Content: CustomStringConvertible {
    public var description: String {
        switch self {
        case .clue(let clue): "\(clue)"
        case .operator(let `operator`): "\(`operator`)"
        }
    }
}

extension CageInfo.Content.Operator: CustomStringConvertible {
    public var description: String {
        switch self {
        case .add: "+"
        case .subtract: "−"
        case .multiply: "×"
        case .divide: "÷"
        }
    }
}

