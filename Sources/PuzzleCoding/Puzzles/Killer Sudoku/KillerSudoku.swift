//
//  KillerSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

public struct KillerSudoku: Equatable {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], grid: Grid) {
        let coding = KillerCoding(size: grid.size, shapeRanges: Self.shapeRanges(for: grid.size))
        coding.checkPreconditions(clues: cageClues, shapes: [cageShapes])

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.grid = grid
    }
}

extension KillerSudoku {
    static var cageRange: ClosedRange<Int> { 1...5 }
    static func shapeRanges(for size: Size) -> [ClosedRange<Int>] {
        [cageRange]
    }
    var shapes: [[Int]] {
        [cageShapes]
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

extension KillerSudoku: CustomStringConvertible {
    public var description: String { "\(PuzzleType.killerSudoku) \(grid.size)" }
}
