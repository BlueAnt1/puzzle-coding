//
//  Str8ts.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

public struct Str8ts {
    public let colors: [Int]
    public let grid: Grid

    public init(colors: [Int], grid: Grid) {
        precondition(colors.count == grid.count)
        self.colors = colors
        self.grid = grid
    }
}

extension Str8ts {
    public enum Version: CaseIterable, Sendable {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any Coder<Str8ts>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(from input: String) -> (puzzle: Str8ts, version: Version)? {
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
