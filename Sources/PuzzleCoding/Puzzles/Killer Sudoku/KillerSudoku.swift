//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

public struct KillerSudoku {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let grid: Grid
    static var shapeRanges: [ClosedRange<Int>] { [1...5] }

    public init(cageClues: [Int], cageShapes: [Int], grid: Grid) {
        precondition(grid.count == cageClues.count && grid.count == cageShapes.count)
        let maxCageClue = grid.size.valueRange.reduce(0, +)
        precondition(cageClues.allSatisfy { (0...maxCageClue).contains($0) })
        precondition(cageShapes.allSatisfy { Self.shapeRanges[0].contains($0) })

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.grid = grid
    }
}

extension KillerSudoku {
    public enum Version: CaseIterable, Sendable {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any Coder<KillerSudoku>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(from input: String) -> (puzzle: KillerSudoku, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(from: input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(from input: String, using version: Version) -> KillerSudoku? {
        version.coder.decode(from: input)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(self)
    }
}
