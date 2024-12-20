//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

/// KillerJigsaw puzzle coder.
public struct KillerJigsaw: Equatable {
    private let cells: [Cell]
    public var version: Version

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }

        let ranges = KillerJigsaw.ranges(for: size)

        for cell in cells {
            guard let region = cell.region,
                  case .cage(let cageID, let op) = cell.clue
            else { throw Error.missingData }

            guard ranges.shape.contains(region),
                  ranges.cageShape.contains(cageID),
                  cell.progress.map({ $0.isValid(in: size.valueRange) }) ?? true
            else { throw Error.outOfRange }

            if case .add(let value) = op {
                guard ranges.cageClue.contains(value) else { throw Error.outOfRange }
            } else if op != nil {
                // some other operator
                throw Error.outOfRange
            }
        }

        self.cells = cells as? Array ?? Array(cells)
        self.version = version
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (shape: ClosedRange<Int>,
                                           cageShape: ClosedRange<Int>,
                                           cageContent: ClosedRange<Int>,
                                           cageClue: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        let cageTransform = KillerCageTransform(size: size)
        return (size.valueRange,
                1...5,
                cageTransform.range,
                cageTransform.clueRange,
                CellContentTransform(size: size).range)
    }
}

extension KillerJigsaw: Puzzle {
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
        static func encode(_ puzzle: KillerJigsaw) -> String
        static func decode(_ input: String) -> KillerJigsaw?
    }
}

extension KillerJigsaw: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension KillerJigsaw: RawRepresentable {
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

extension KillerJigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerJigsaw) \(Size(gridCellCount: cells.count)!)" }
}
