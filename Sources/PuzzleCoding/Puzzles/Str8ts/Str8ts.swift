//
//  Str8ts.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// Str8ts puzzle coder.
public struct Str8ts: Equatable {
    private let cells: [Cell]
    public var version: Version
    let type: PuzzleType

    init(cells: some Collection<Cell>, version: Version = .current, type: PuzzleType) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }
        guard cells.allSatisfy({ $0.progress.map { $0.isValid(in: size.valueRange) } ?? true })
        else { throw Error.outOfRange }

        self.cells = cells as? Array ?? Array(cells)
        self.version = version
        self.type = type
    }

    var size: Size { Size(gridCellCount: cells.count)! }
}

extension Str8ts: Puzzle {
    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        try self.init(cells: cells, version: version, type: .str8ts)
    }

    public enum Version: CaseIterable, Sendable {
        case versionB

        public static var current: Version { .versionB }

        fileprivate var coder: any Coder.Type {
            switch self {
            case .versionB: VersionB.self
            }
        }
    }

    protocol Coder {
        static func encode(_ puzzle: Str8ts) -> String
        static func decode(_ input: String, type: PuzzleType) -> Str8ts?
    }
}

extension Str8ts: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension Str8ts: RawRepresentable {
    public var rawValue: String { version.coder.encode(self) }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: .str8ts) {
                self = puzzle
                return
            }
        }
        return nil
    }
}

extension Str8ts: CustomStringConvertible {
    public var description: String { "\(type) \(size)" }
}

// MARK: - Str8tsB

/// Str8tsB puzzle coder.
public struct Str8tsB: Equatable {
    private static var type: PuzzleType { .str8tsB }
    private var str8ts: Str8ts

    init(str8ts: Str8ts) {
        assert(str8ts.type == Self.type)
        self.str8ts = str8ts
    }

    var size: Size { str8ts.size }
}

extension Str8tsB: Puzzle {
    public typealias Version = Str8ts.Version
    public var version: Version {
        get { str8ts.version }
        set { str8ts.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.str8ts = try Str8ts(cells: cells, version: version, type: Self.type)
    }
}

extension Str8tsB: RandomAccessCollection {
    public var startIndex: Int { str8ts.startIndex }
    public var endIndex: Int { str8ts.endIndex }
    public subscript(_ position: Int) -> Cell { str8ts[position] }
}

extension Str8tsB: RawRepresentable {
    public var rawValue: String { str8ts.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.str8ts = puzzle
                return
            }
        }
        return nil
    }
}

extension Str8tsB: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}

// MARK: - Str8tsBX

/// Str8tsBX puzzle coder.
public struct Str8tsBX: Equatable {
    private static var type: PuzzleType { .str8tsBX }
    private var str8ts: Str8ts

    init(str8ts: Str8ts) {
        assert(str8ts.type == Self.type)
        self.str8ts = str8ts
    }

    var size: Size { str8ts.size }
}

extension Str8tsBX: Puzzle {
    public typealias Version = Str8ts.Version
    public var version: Version {
        get { str8ts.version }
        set { str8ts.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.str8ts = try Str8ts(cells: cells, version: version, type: Self.type)
    }
}

extension Str8tsBX: RandomAccessCollection {
    public var startIndex: Int { str8ts.startIndex }
    public var endIndex: Int { str8ts.endIndex }
    public subscript(_ position: Int) -> Cell { str8ts[position] }
}

extension Str8tsBX: RawRepresentable {
    public var rawValue: String { str8ts.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.str8ts = puzzle
                return
            }
        }
        return nil
    }
}

extension Str8tsBX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}

// MARK: - Str8tsX

/// Str8tsX puzzle coder.
public struct Str8tsX: Equatable {
    private static var type: PuzzleType { .str8tsX }
    private var str8ts: Str8ts

    init(str8ts: Str8ts) {
        assert(str8ts.type == Self.type)
        self.str8ts = str8ts
    }

    var size: Size { str8ts.size }
}

extension Str8tsX: Puzzle {
    public typealias Version = Str8ts.Version
    public var version: Version {
        get { str8ts.version }
        set { str8ts.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.str8ts = try Str8ts(cells: cells, version: version, type: Self.type)
    }
}

extension Str8tsX: RandomAccessCollection {
    public var startIndex: Int { str8ts.startIndex }
    public var endIndex: Int { str8ts.endIndex }
    public subscript(_ position: Int) -> Cell { str8ts[position] }
}

extension Str8tsX: RawRepresentable {
    public var rawValue: String { str8ts.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.str8ts = puzzle
                return
            }
        }
        return nil
    }
}

extension Str8tsX: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}
