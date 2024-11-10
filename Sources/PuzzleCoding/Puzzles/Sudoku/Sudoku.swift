//
//  Sudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/18/24.
//

/// Sudoku puzzle coder.
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
    public enum Version: CodingVersion {
        /// Converts solutions to clues & removes candidates.
        case clue
        /// Includes puzzle progress. This encoding solves _naked singles_.
        case noNakedSingles
        /// Includes puzzle progress.
        case versionB

        public static var current: Version { .versionB }

        var coder: any VersionCoder<Sudoku>.Type {
            switch self {
            case .clue: Clue.self
            case .noNakedSingles: NoNakedSingles.self
            case .versionB: VersionB.self
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

/// Windoku puzzle coder.
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
        guard let sudoku = Sudoku.decode(input, using: version),
              sudoku.type == Self.type
        else { return nil }
        return Windoku(grid: sudoku.grid)
    }

    public func encode(using version: Version = .current) -> String {
        Sudoku(grid: grid, type: Self.type).encode(using: version)
    }
}

extension Windoku: CustomStringConvertible {
    public var description: String { "\(Self.type) \(grid.size)" }
}

// MARK: - SudokuX

/// SudokuX puzzle coder.
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
        guard let sudoku = Sudoku.decode(input, using: version),
              sudoku.type == Self.type
        else { return nil }
        return SudokuX(grid: sudoku.grid)
    }

    public func encode(using version: Version = .current) -> String {
        Sudoku(grid: self.grid, type: Self.type).encode(using: version)
    }
}

extension SudokuX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(grid.size)" }
}
