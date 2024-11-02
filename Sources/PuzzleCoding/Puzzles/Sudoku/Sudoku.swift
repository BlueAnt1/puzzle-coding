//
//  Sudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/18/24.
//

/// A Sudoku puzzle coder.
public struct Sudoku: Equatable {
    /// The puzzle content.
    public let grid: Grid
    let type: PuzzleType.SudokuType

    /// Creates an instance.
    /// - Parameter grid: the puzzle content.
    public init(grid: Grid) {
        self.init(grid: grid, type: .sudoku)
    }

    init(grid: Grid, type: PuzzleType.SudokuType) {
        self.grid = grid
        self.type = type
    }
}

extension Sudoku {
    /// The coding version.
    public enum Version: CaseIterable, Sendable {
        /// Converts solutions to clues & removes candidates.
        case clue
        /// Includes puzzle progress. This encoding solves _naked singles_.
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

// MARK: - Windoku

/// A Windoku puzzle coder.
public struct Windoku: Equatable {
    /// The puzzle content.
    public let grid: Grid

    /// Creates an instance.
    /// - Parameter grid: the puzzle content.
    public init(grid: Grid) {
        self.grid = grid
    }
}

extension Windoku {
    public typealias Version = Sudoku.Version

    /// Attempt to decode the puzzle from the provided input.
    /// - Parameter input: The value to parse.
    /// - Returns: The puzzle & encoding version if the input is recognized, `nil` otherwise.
    public static func decode(from input: String) -> (puzzle: Windoku, version: Version)? {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(from: input) {
                return (Windoku(grid: puzzle.grid), version)
            }
        }
        return nil
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(Sudoku(grid: self.grid, type: .windoku))
    }
}

// MARK: - SudokuX

/// A SudokuX puzzle coder.
public struct SudokuX: Equatable {
    /// The puzzle content.
    public let grid: Grid

    /// Creates an instance.
    /// - Parameter grid: the puzzle content.
    public init(grid: Grid) {
        self.grid = grid
    }
}

extension SudokuX {
    public typealias Version = Sudoku.Version

    /// Attempt to decode the puzzle from the provided input.
    /// - Parameter input: The value to parse.
    /// - Returns: The puzzle & encoding version if the input is recognized, `nil` otherwise.
    public static func decode(from input: String) -> (puzzle: SudokuX, version: Version)? {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(from: input) {
                return (SudokuX(grid: puzzle.grid), version)
            }
        }
        return nil
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(Sudoku(grid: self.grid, type: .sudokuX))
    }
}

