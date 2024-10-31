//
//  Sudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/18/24.
//

/// A Sudoku puzzle coder.
public struct Sudoku {
    /// The puzzle content.
    public let grid: Grid

    /// Creates an instance.
    /// - Parameter grid: the puzzle content.
    public init(grid: Grid) {
        self.grid = grid
    }
}

extension Sudoku {
    /// The coding version.
    public enum Version: CaseIterable, Sendable {
        /// Converts solutions to clues & removes candidates.
        case clue
        /// Includes puzzle progress. Unfortunately this encoding solves _naked singles_.
        case shift
        /// Includes puzzle progress.
        case offset

        /// The current version.
        public static var current: Version { .offset }

        fileprivate var coder: any Coder<Sudoku>.Type {
            switch self {
            case .clue: Clue.self
            case .shift: Shift.self
            case .offset: Offset.self
            }
        }
    }

    /// Attempt to decode the puzzle from the provided input.
    /// - Parameter input: The value to parse.
    /// - Returns: The puzzle & encoding version if the input is recognized, `nil` otherwise.
    public static func decode(from input: String) -> (puzzle: Sudoku, version: Version)? {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(from: input) {
                return (puzzle, version)
            }
        }
        return nil
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(self)
    }
}
