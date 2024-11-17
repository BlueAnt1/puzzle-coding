//
//  JigsawSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// JigsawSudoku puzzle coder.
public struct JigsawSudoku: Equatable {
    private let cells: [Cell]

    public init(cells: [Cell]) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }
        guard cells.allSatisfy({ $0.box?.shape != nil }),
              cells.allSatisfy({ $0.content.map { $0.isValid(in: size.valueRange) } ?? true })
        else { throw Error.outOfRange }

        self.cells = cells
    }

    static func boxRange(in size: Size) -> ClosedRange<Int> {
        size.valueRange
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (boxShape: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        return (size.valueRange,
                CellContentTransform(size: size).range)
    }
}

extension JigsawSudoku: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension JigsawSudoku: PuzzleCodable {
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

    public static func decode(_ input: String, using version: Version) -> JigsawSudoku? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension JigsawSudoku: CustomStringConvertible {
    public var description: String { "\(PuzzleType.jigsawSudoku) \(size)" }
}
