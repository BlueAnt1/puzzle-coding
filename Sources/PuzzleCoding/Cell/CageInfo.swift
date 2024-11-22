//
//  CageInfo.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

/// Cage related information about a cell.
///
/// >Important: Be sure you understand how to store information for [Cages](<doc:CageContentTransform>) and <doc:Shapes>.
public struct CageInfo: Equatable, Sendable {
    /// The cage containing the cell.
    public var cage: Int
    /// The cage content such as a clue or operator.
    public var clue: Clue?

    public enum Clue: Equatable, Sendable {
        case add(Int)
        case subtract(Int)
        case multiply(Int)
        case divide(Int)

        var operatorValue: Int {
            switch self {
            case .add: 1
            case .subtract: 2
            case .multiply: 3
            case .divide: 4
            }
        }

        var value: Int {
            switch self {
            case .add(let value), .subtract(let value), .multiply(let value), .divide(let value):
                value
            }
        }
    }
}

extension CageInfo.Clue {
    init?(operator: Int, value: Int) {
        guard value > 0 else { return nil }
        switch `operator` {
        case 1: self = .add(value)
        case 2: self = .subtract(value)
        case 3: self = .multiply(value)
        case 4: self = .divide(value)
        default: return nil
        }
    }
}

extension CageInfo.Clue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .add(let value): "\(value)+"
        case .subtract(let value): "\(value)−"
        case .multiply(let value): "\(value)×"
        case .divide(let value): "\(value)÷"
        }
    }
}
