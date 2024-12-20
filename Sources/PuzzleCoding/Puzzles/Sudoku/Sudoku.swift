//
//  Sudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/18/24.
//

/// Sudoku puzzle coder.
public struct Sudoku: Equatable {
    /// The puzzle content.
    private let cells: [Cell]
    public var version: Version
    let type: PuzzleType

    init(cells: some Collection<Cell>, version: Version, type: PuzzleType) throws {
        assert([.sudoku, .sudokuX, .windoku].contains(type))
        guard let size = Size(gridCellCount: cells.count),
              Size.sudokuCases.contains(size)
        else { throw Error.invalidSize }
        guard cells.allSatisfy({ $0.progress.map { $0.isValid(in: size.valueRange) } ?? true })
        else { throw Error.outOfRange }
        self.cells = cells as? Array ?? Array(cells)
        self.version = version
        self.type = type
    }

    var size: Size { Size(gridCellCount: cells.count)! }
}

extension Sudoku: Puzzle {
    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        try self.init(cells: cells, version: version, type: .sudoku)
    }

    public enum Version: CaseIterable, Sendable {
        /// Converts solutions to clues & removes candidates.
        case clue
        /// Includes puzzle progress.
        case versionB

        public static var current: Version { .versionB }

        fileprivate var coder: any Coder.Type {
            switch self {
            case .clue: Clue.self
            case .versionB: VersionB.self
            }
        }
    }

    protocol Coder {
        static func encode(_ puzzle: Sudoku) -> String
        static func decode(_ input: String, type: PuzzleType) -> Sudoku?
    }
}

extension Sudoku: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension Sudoku: RawRepresentable {
    public var rawValue: String { version.coder.encode(self) }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: .sudoku) {
                self = puzzle
                return
            }
        }
        return nil
    }
}

extension Sudoku: CustomStringConvertible {
    public var description: String { "\(type) \(size)" }
}

// MARK: - Windoku

/// Windoku puzzle coder.
public struct Windoku: Equatable {
    private static var type: PuzzleType { .windoku }
    private var sudoku: Sudoku

    init(sudoku: Sudoku) {
        assert(sudoku.type == Self.type)
        self.sudoku = sudoku
    }

    var size: Size { sudoku.size }
}

extension Windoku: Puzzle {
    public typealias Version = Sudoku.Version
    public var version: Version {
        get { sudoku.version }
        set { sudoku.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.sudoku = try Sudoku(cells: cells, version: version, type: Self.type)
    }
}

extension Windoku: RandomAccessCollection {
    public var startIndex: Int { sudoku.startIndex }
    public var endIndex: Int { sudoku.endIndex }
    public subscript(_ position: Int) -> Cell { sudoku[position] }
}

extension Windoku: RawRepresentable {
    public var rawValue: String { sudoku.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.sudoku = puzzle
                return
            }
        }
        return nil
    }
}

extension Windoku: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}

// MARK: - SudokuX

/// SudokuX puzzle coder.
public struct SudokuX: Equatable {
    private static var type: PuzzleType { .sudokuX }
    private var sudoku: Sudoku

    init(sudoku: Sudoku) {
        assert(sudoku.type == Self.type)
        self.sudoku = sudoku
    }

    var size: Size { sudoku.size }
}

extension SudokuX: RandomAccessCollection {
    public var startIndex: Int { sudoku.startIndex }
    public var endIndex: Int { sudoku.endIndex }
    public subscript(_ position: Int) -> Cell { sudoku[position] }
}

extension SudokuX: Puzzle {
    public typealias Version = Sudoku.Version
    public var version: Version {
        get { sudoku.version }
        set { sudoku.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.sudoku = try Sudoku(cells: cells, version: version, type: Self.type)
    }
}

extension SudokuX: RawRepresentable {
    public var rawValue: String { sudoku.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.sudoku = puzzle
                return
            }
        }
        return nil
    }
}

extension SudokuX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}
