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
    public static func decode(_ input: String) -> (puzzle: Sudoku, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(_ input: String, using version: Version) -> Sudoku? {
        version.coder.decode(from: input)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension Sudoku: CustomStringConvertible {
    public var description: String { "\(type) \(grid.size)" }
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
    private static var type: PuzzleType.SudokuType { .windoku }

    /// Attempt to decode the puzzle from the provided input.
    /// - Parameter input: The value to parse.
    /// - Returns: The puzzle & encoding version if the input is recognized, `nil` otherwise.
    public static func decode(_ input: String) -> (puzzle: Windoku, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(_ input: String, using version: Version) -> Windoku? {
        guard let sudoku = version.coder.decode(from: input) else { return nil }
        return Windoku(grid: sudoku.grid)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(using version: Version = .current) -> String {
        version.coder.encode(Sudoku(grid: self.grid, type: Self.type))
    }
}

extension Windoku: CustomStringConvertible {
    public var description: String { "\(Self.type) \(grid.size)" }
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
    private static var type: PuzzleType.SudokuType { .sudokuX }

    /// Attempt to decode the puzzle from the provided input.
    /// - Parameter input: The value to parse.
    /// - Returns: The puzzle & encoding version if the input is recognized, `nil` otherwise.
    public static func decode(_ input: String) -> (puzzle: SudokuX, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(_ input: String, using version: Version) -> SudokuX? {
        guard let sudoku = version.coder.decode(from: input) else { return nil }
        return SudokuX(grid: sudoku.grid)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(using version: Version = .current) -> String {
        version.coder.encode(Sudoku(grid: self.grid, type: Self.type))
    }
}

extension SudokuX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(grid.size)" }
}
