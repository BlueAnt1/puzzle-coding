//
//  KenKen.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/15/24.
//

/// KenKen puzzle coder.
public struct KenKen: Equatable, Sendable {
    private let cells: [Cell]
    public var version: Version
    let type: PuzzleType

    init(cells: some Collection<Cell>, version: Version, type: PuzzleType) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }

        let ranges = KenKen.ranges(for: size)

        for cell in cells {
            guard case .cage(id: let cageID, operator: let op) = cell.clue
            else { throw Error.missingData }

            guard ranges.cageShape.contains(cageID),
                  cell.progress.map({ $0.isValid(in: size.valueRange) }) ?? true
            else { throw Error.outOfRange }

            if let operand = op?.operand {
                guard ranges.cageClue.contains(operand) else { throw Error.outOfRange }
            }
        }

        self.cells = cells as? Array ?? Array(cells)
        self.version = version
        self.type = type
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (cageShape: ClosedRange<Int>,
                                           cageContent: ClosedRange<Int>,
                                           cageClue: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        let cageTransform = KenCageTransform(size: size)
        return (1...5,
                cageTransform.range,
                cageTransform.clueRange,
                CellContentTransform(size: size).range)
    }
}

extension KenKen: Puzzle {
    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        try self.init(cells: cells, version: version, type: .kenken)
    }

    public enum Version: CaseIterable, Sendable {
        case versionC

        public static var current: Version { .versionC }

        fileprivate var coder: any Coder.Type {
            switch self {
            case .versionC: VersionC.self
            }
        }
    }

    protocol Coder {
        static func encode(_ puzzle: KenKen) -> String
        static func decode(_ input: String, type: PuzzleType) -> KenKen?
    }
}

extension KenKen: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension KenKen: RawRepresentable {
    public var rawValue: String { version.coder.encode(self) }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: .kenken) {
                self = puzzle
                return
            }
        }
        return nil
    }
}

extension KenKen: CustomStringConvertible {
    public var description: String { "\(PuzzleType.kenken) \(size)" }
}

// MARK: - KenDoku

/// KenDoku puzzle coder.
public struct KenDoku: Equatable {
    private static var type: PuzzleType { .kendoku }
    private var kenKen: KenKen

    init(kenKen: KenKen) {
        assert(kenKen.type == Self.type)
        self.kenKen = kenKen
    }

    var size: Size { kenKen.size }
}

extension KenDoku: Puzzle {
    public typealias Version = KenKen.Version
    public var version: Version {
        get { kenKen.version }
        set { kenKen.version = newValue }
    }

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        self.kenKen = try KenKen(cells: cells, version: version, type: Self.type)
    }
}

extension KenDoku: RandomAccessCollection {
    public var startIndex: Int { kenKen.startIndex }
    public var endIndex: Int { kenKen.endIndex }
    public subscript(_ position: Int) -> Cell { kenKen[position] }
}

extension KenDoku: RawRepresentable {
    public var rawValue: String { kenKen.rawValue }

    public init?(rawValue: String) {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(rawValue, type: Self.type) {
                self.kenKen = puzzle
                return
            }
        }
        return nil
    }
}

extension KenDoku: CustomStringConvertible {
    public var description: String { "\(Self.type) \(size)" }
}
