//
//  KenKen.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/15/24.
//

/// KenKen puzzle coder.
///
/// > Note: KenKen® is a registered trademark of Nextoy, LLC.
public struct KenKen: Equatable, Sendable {
    private let cells: [Cell]
    public var version: Version
    
    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }

        let ranges = KenKen.ranges(for: size)

        for cell in cells {
            guard let cage = cell.cage
            else { throw Error.missingData }

            guard ranges.cageShape.contains(cage.cage),
                  cell.content.map({ $0.isValid(in: size.valueRange) }) ?? true
            else { throw Error.outOfRange }

            switch cage.content {
            case .clue(let clue):
                guard ranges.cageClue.contains(clue) else { throw Error.outOfRange }
            case .operator: break
            case nil: break
            }
        }

        self.cells = cells as? Array ?? Array(cells)
        self.version = version
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (cageShape: ClosedRange<Int>,
                                           cageContent: ClosedRange<Int>,
                                           cageClue: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        let cageTransform = KenCageContentTransform(size: size)
        return (1...5,
                cageTransform.range,
                cageTransform.clueRange,
                CellContentTransform(size: size).range)
    }
}

extension KenKen: Puzzle {
    public enum Version: CodingVersion {
        case versionB

        public static var current: Version { .versionB }

        fileprivate var coder: any Coder.Type {
            switch self {
            case .versionB: VersionB.self
            }
        }
    }

    protocol Coder {
        static func encode(_ puzzle: KenKen) -> String
        static func decode(_ input: String) -> KenKen?
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
            if let puzzle = version.coder.decode(rawValue) {
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
