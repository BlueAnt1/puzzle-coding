//
//  CellContent.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

/// The information stored in a cell.
public enum CellContent: Equatable, Sendable {
    /// A puzzle clue.
    case clue(Int)
    /// A solved value.
    case solution(Int)
    /// A set of candidates.
    case candidates(Set<Int>)

    func isValid(in range: ClosedRange<Int>) -> Bool {
        switch self {
        case .solution(let value), .clue(let value):
            range.contains(value)
        case .candidates(let candidates):
            candidates.isSubset(of: range)
        }
    }
}
