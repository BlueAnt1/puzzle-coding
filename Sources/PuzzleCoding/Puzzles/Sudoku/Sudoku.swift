//
//  Sudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/18/24.
//

/// Sudoku puzzle coder.
public struct Sudoku: Equatable {
    /// The puzzle content.
    public let cells: [Cell]
    let type: PuzzleType

    /// Creates an instance.
    /// - Parameter cells: the puzzle content.
    public init(cells: [Cell]) throws {
        try self.init(cells: cells, type: .sudoku)
    }

    init(cells: [Cell], type: PuzzleType) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }
        guard cells.allSatisfy({ $0.content.map { $0.isValid(in: size.valueRange) } ?? true }),
              [.sudoku, .sudokuX, .windoku].contains(type)
        else { throw Error.outOfRange }
        self.cells = cells
        self.type = type
    }

    public var size: Size { Size(gridCellCount: cells.count)! }
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

        fileprivate var coder: any Coder.Type {
            switch self {
            case .clue: Clue.self
            case .noNakedSingles: NoNakedSingles.self
            case .versionB: VersionB.self
            }
        }
    }

    protocol Coder {
        static func encode(_ puzzle: Sudoku) -> String
        static func decode(_ input: String, type: PuzzleType) -> Sudoku?
    }

    public static func decode(_ input: String, using version: Version) -> Sudoku? {
        version.coder.decode(input, type: .sudoku)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension Sudoku: CustomStringConvertible {
    public var description: String { "\(type) \(size)" }
}

// MARK: - Windoku

/// Windoku puzzle coder.
public struct Windoku: Equatable {
    private let sudoku: Sudoku

    /// Creates an instance.
    /// - Parameter cells: the puzzle content.
    public init(cells: [Cell]) throws {
        self.sudoku = try Sudoku(cells: cells, type: Self.type)
    }

    init(sudoku: Sudoku) {
        assert(sudoku.type == Self.type)
        self.sudoku = sudoku
    }

    /// The puzzle content.
    public var cells: [Cell] { sudoku.cells }
    public var size: Size { sudoku.size }
}

extension Windoku: PuzzleCoder {
    public typealias Version = Sudoku.Version
    private static var type: PuzzleType { .windoku }

    public static func decode(_ input: String, using version: Version) -> Windoku? {
        guard let sudoku = version.coder.decode(input, type: Self.type) else { return nil }
        return Windoku(sudoku: sudoku)
    }

    public func encode(using version: Version = .current) -> String {
        sudoku.encode(using: version)
    }
}

extension Windoku: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}

// MARK: - SudokuX

/// SudokuX puzzle coder.
public struct SudokuX: Equatable {
    private let sudoku: Sudoku

    /// Creates an instance.
    /// - Parameter cells: the puzzle content.
    public init(cells: [Cell]) throws {
        self.sudoku = try Sudoku(cells: cells, type: Self.type)
    }

    init(sudoku: Sudoku) {
        assert(sudoku.type == Self.type)
        self.sudoku = sudoku
    }

    /// The puzzle content.
    public var cells: [Cell] { sudoku.cells }
    public var size: Size { sudoku.size }
}

extension SudokuX: PuzzleCoder {
    public typealias Version = Sudoku.Version
    private static var type: PuzzleType { .sudokuX }

    public static func decode(_ input: String, using version: Version) -> SudokuX? {
        guard let sudoku = version.coder.decode(input, type: Self.type) else { return nil }
        return SudokuX(sudoku: sudoku)
    }

    public func encode(using version: Version = .current) -> String {
        sudoku.encode(using: version)
    }
}

extension SudokuX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}
