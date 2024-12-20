//
//  Progress.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

/// The player's guesses & candidates.
public enum Progress: Equatable, Sendable {
    /// A solved value.
    case guess(Int)
    /// A set of candidates.
    case candidates(Set<Int>)

    var normalized: Progress? {
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
