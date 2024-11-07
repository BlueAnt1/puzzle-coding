//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

/// A KillerSudoku puzzle coder.
public struct KillerSudoku: Equatable {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], grid: Grid) {
        let ranges = Self.ranges(for: grid.size)

        precondition(cageClues.count == cageShapes.count
                     && cageClues.count == grid.size.gridCellCount
                     && cageClues.allSatisfy(ranges.cageClue.contains)
                     && cageShapes.allSatisfy(ranges.cageShape.contains))

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.grid = grid
    }

    static func ranges(for size: Size) -> (cageClue: ClosedRange<Int>, cageShape: ClosedRange<Int>){
        let maxClueValue = size.valueRange.reduce(0, +)
        let cageClueRange = 0...maxClueValue
        let cageShapeRange = 1...5
        return (cageClueRange, cageShapeRange)
    }
}

extension KillerSudoku: PuzzleCoder {
    public enum Version: CodingVersion {
        case versionB

        public static var current: Version { .versionB }

        fileprivate var coder: any VersionCoder<KillerSudoku>.Type {
            switch self {
            case .versionB: VersionB.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> KillerSudoku? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension KillerSudoku: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerSudoku) \(grid.size)" }
}
