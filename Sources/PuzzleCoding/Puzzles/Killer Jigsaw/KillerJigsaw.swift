//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

/// KillerJigsaw puzzle coder.
public struct KillerJigsaw: Equatable {
    private let cells: [Cell]

    public init(cells: [Cell]) throws {
        guard let size = Size(gridCellCount: cells.count)
        else { throw Error.invalidSize }

        let ranges = KillerJigsaw.ranges(for: size)

        for cell in cells {
            guard let box = cell.box,
                  let cage = cell.cage
            else { throw Error.missingData }

            guard ranges.boxShape.contains(box.shape),
                  ranges.cageShape.contains(cage.shape),
                  cell.content.map({ $0.isValid(in: size.valueRange) }) ?? true
            else { throw Error.outOfRange }

            switch cage.content {
            case .clue(let clue):
                guard ranges.cageClue.contains(clue) else { throw Error.outOfRange }
            case .operator(let op):
                guard op == .add else { throw Error.outOfRange }
            }
        }

        self.cells = cells
    }

    var size: Size { Size(gridCellCount: cells.count)! }

    static func ranges(for size: Size) -> (boxShape: ClosedRange<Int>,
                                           cageShape: ClosedRange<Int>,
                                           cageContent: ClosedRange<Int>,
                                           cageClue: ClosedRange<Int>,
                                           cellContent: ClosedRange<Int>) {
        let cageTransform = KillerCageContentTransform(size: size)
        return (size.valueRange,
                1...5,
                cageTransform.range,
                cageTransform.clueRange,
                CellContentTransform(size: size).range)
    }
}

extension KillerJigsaw: RandomAccessCollection {
    public var startIndex: Int { cells.startIndex }
    public var endIndex: Int { cells.endIndex }
    public subscript(_ position: Int) -> Cell { cells[position] }
}

extension KillerJigsaw: PuzzleCoder {
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
        static func encode(_ puzzle: KillerJigsaw) -> String
        static func decode(_ input: String) -> KillerJigsaw?
    }

    public static func decode(_ input: String, using version: Version) -> KillerJigsaw? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension KillerJigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerJigsaw) \(Size(gridCellCount: cells.count)!)" }
}
