//
//  Killer.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

public struct Killer {
    public let cageClues: [Int]
    public let cageShapes: [Int]
    public let grid: Grid

    public init(cageClues: [Int], cageShapes: [Int], grid: Grid) {
        precondition(grid.count == cageClues.count && grid.count == cageShapes.count)
        let maxCageClue = grid.size.valueRange.reduce(0, +)
        precondition(cageClues.allSatisfy { (0...maxCageClue).contains($0) })
        precondition(cageShapes.allSatisfy { (1...5).contains($0) })

        self.cageClues = cageClues
        self.cageShapes = cageShapes
        self.grid = grid
    }
}

extension Killer {
    public enum Version: CaseIterable, Sendable {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any Coder<Killer>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(from input: String) -> (puzzle: Killer, version: Version)? {
        for version in Version.allCases {
            if let puzzle = version.coder.decode(from: input) {
                return (puzzle, version)
            }
        }
        return nil
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(self)
    }
}
