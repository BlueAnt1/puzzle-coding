//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

/// KillerJigsaw puzzle coder.
public struct KillerJigsaw: Equatable {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let boxShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], boxShapes: [Int], grid: Grid) {
        let ranges = Self.ranges(for: grid.size)

        precondition(cageClues.count == cageShapes.count
                     && cageClues.count == boxShapes.count
                     && cageClues.count == grid.size.gridCellCount
                     && cageClues.allSatisfy(ranges.cageClue.contains)
                     && cageShapes.allSatisfy(ranges.cageShape.contains)
                     && boxShapes.allSatisfy(ranges.boxShape.contains))

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.boxShapes = boxShapes
        self.grid = grid
    }

    static func ranges(for size: Size) -> (cageClue: ClosedRange<Int>, cageShape: ClosedRange<Int>, boxShape: ClosedRange<Int>){
        let maxClueValue = size.valueRange.reduce(0, +)
        let cageClueRange = 0...maxClueValue
        let cageShapeRange = 1...5
        let boxShapeRange = size.valueRange
        return (cageClueRange, cageShapeRange, boxShapeRange)
    }
}


extension KillerJigsaw: PuzzleCoder {
    public enum Version: CodingVersion {
        case versionB
        case experimental

        public static var current: Version { .versionB }

        fileprivate var coder: any VersionCoder<KillerJigsaw>.Type {
            switch self {
            case .versionB: VersionB.self
            case .experimental: Experimental.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> KillerJigsaw? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension KillerJigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerJigsaw) \(grid.size)" }
}
