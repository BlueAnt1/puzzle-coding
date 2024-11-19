//
//  JigsawSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// JigsawSudoku puzzle coder.
public struct JigsawSudoku: Equatable {
    private let cells: [Cell]
    public var version: Version

    public init(cells: some Collection<Cell>, version: Version = .current) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }
        guard cells.allSatisfy({ $0.group != nil }),
              cells.allSatisfy({ $0.content.map { $0.isValid(in: size.valueRange) } ?? true })
        else { throw Error.outOfRange }

        self.cells = cells as? Array ?? Array(cells)
        self.version = version
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (shape: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        return (size.valueRange,
                CellContentTransform(size: size).range)
    }
}

extension JigsawSudoku: Puzzle {
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
        static func encode(_ puzzle: JigsawSudoku) -> String
        static func decode(_ input: String) -> JigsawSudoku?
    }
}

extension JigsawSudoku: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension JigsawSudoku: RawRepresentable {
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

extension JigsawSudoku: CustomStringConvertible {
    public var description: String { "\(PuzzleType.jigsawSudoku) \(size)" }
}
