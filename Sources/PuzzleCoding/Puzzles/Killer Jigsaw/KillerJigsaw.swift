//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

public struct KillerJigsaw: Equatable {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let boxShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], boxShapes: [Int], grid: Grid) {
        let coding = KillerCoding(size: grid.size, shapeRanges: Self.shapeRanges(for: grid.size))
        coding.checkPreconditions(clues: cageClues, shapes: [cageShapes, boxShapes])

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.boxShapes = boxShapes
        self.grid = grid
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

extension KillerJigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerJigsaw) \(grid.size)" }
}
