//
//  CellContent.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

extension Cell {
    /// The information stored in a cell.
    public enum Content: Equatable, Sendable {
        /// A puzzle clue.
        case clue(Int)
        /// A empty black cell.
        case blackEmpty
        /// A black puzzle clue (Str8ts).
        case blackClue(Int)
        /// A solved value.
        case solution(Int)
        /// A set of candidates.
        case candidates(Set<Int>)

        func isValid(in range: ClosedRange<Int>) -> Bool {
            switch self {
            case .solution(let value), .clue(let value), .blackClue(let value):
                range.contains(value)
            case .candidates(let candidates):
                candidates.isSubset(of: range)
            case .blackEmpty: true
            }
        }
    }
}
