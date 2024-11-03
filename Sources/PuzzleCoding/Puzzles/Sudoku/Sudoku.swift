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

extension Sudoku: PuzzleCoder {
    public enum Version: VersionProtocol {
        /// Converts solutions to clues & removes candidates.
        case clue
        /// Includes puzzle progress. This encoding solves _naked singles_.
        case shift
        /// Includes puzzle progress.
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any VersionCoder<Sudoku>.Type {
            switch self {
            case .clue: Clue.self
            case .shift: Shift.self
            case .offset: Offset.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> Sudoku? {
        version.coder.decode(input)
    }

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

extension Windoku: PuzzleCoder {
    public typealias Version = Sudoku.Version
    private static var type: PuzzleType.SudokuType { .windoku }

    public static func decode(_ input: String, using version: Version) -> Windoku? {
        guard let sudoku = version.coder.decode(input) else { return nil }
        return Windoku(grid: sudoku.grid)
    }

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

extension SudokuX: PuzzleCoder {
    public typealias Version = Sudoku.Version
    private static var type: PuzzleType.SudokuType { .sudokuX }

    public static func decode(_ input: String, using version: Version) -> SudokuX? {
        guard let sudoku = version.coder.decode(input) else { return nil }
        return SudokuX(grid: sudoku.grid)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(Sudoku(grid: self.grid, type: Self.type))
    }
}

extension SudokuX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(grid.size)" }
}
