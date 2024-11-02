//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

public struct KillerJigsaw {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let boxShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], boxShapes: [Int], grid: Grid) {
        precondition(grid.count == cageClues.count && grid.count == cageShapes.count && grid.count == boxShapes.count)
        let maxCageClue = grid.size.valueRange.reduce(0, +)
        precondition(cageClues.allSatisfy { (0...maxCageClue).contains($0) })
        precondition(cageShapes.allSatisfy { Self.cageRange.contains($0) })
        precondition(boxShapes.allSatisfy { grid.size.valueRange.contains($0) })

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.boxShapes = boxShapes
        self.grid = grid
    }
}

extension KillerJigsaw {
    public enum Version: CaseIterable, Sendable {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any Coder<KillerJigsaw>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(from input: String) -> (puzzle: KillerJigsaw, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(from: input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(from input: String, using version: Version) -> KillerJigsaw? {
        version.coder.decode(from: input)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension KillerJigsaw {
    static var cageRange: ClosedRange<Int> { 1...5 }
    static func shapeRanges(for size: Size) -> [ClosedRange<Int>] {
        [cageRange, size.valueRange]
    }
    var shapes: [[Int]] {
        [cageShapes, boxShapes]
    }
}
