//
//  CellContent.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

//extension Cell {
//    /// The information stored in a cell.
//    public enum Content: Equatable, Sendable {
//        /// A puzzle clue.
//        case clue(Int)
//        /// A empty black cell.
//        case blackEmpty
//        /// A black puzzle clue (Str8ts).
//        case blackClue(Int)
//        /// A solved value.
//        case guess(Int)
//        /// A set of candidates.
//        case candidates(Set<Int>)
//
//        func isValid(in range: ClosedRange<Int>) -> Bool {
//            switch self {
//            case .guess(let value), .clue(let value), .blackClue(let value):
//                range.contains(value)
//            case .candidates(let candidates):
//                candidates.isSubset(of: range)
//            case .blackEmpty: true
//            }
//        }
//    }
//}
//
extension Cell {
    /// The information stored in a cell.
    public enum Content: Equatable, Sendable {
        /// A solved value.
        case guess(Int)
        /// A set of candidates.
        case candidates(Set<Int>)

        var normalized: Content? {
            switch self {
            case .candidates(let candidates):
                candidates.isEmpty ? nil : self
            case .guess(let value):
                value == 0 ? nil : self
            }
        }

        func isValid(in range: some RangeExpression<Int>) -> Bool {
            switch self {
            case .guess(let value):
                range.contains(value)
            case .candidates(let candidates):
                !candidates.isEmpty && candidates.allSatisfy(range.contains)
            }
        }

        public var guess: Int? {
            if case .guess(let guess) = self {
                guess
            } else {
                nil
            }
        }

        public var candidates: Set<Int>? {
            if case .candidates(let candidates) = self {
                candidates
            } else {
                nil
            }
        }
    }
}
