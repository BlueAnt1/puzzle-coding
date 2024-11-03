//
//  Jigsaw.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

public struct Jigsaw: Equatable {
    public let boxes: [Int]
    public let grid: Grid

    public init(boxes: [Int], grid: Grid) {
        precondition(boxes.count == grid.count)
        self.boxes = boxes
        self.grid = grid
    }
}

extension Jigsaw {
    public enum Version: CaseIterable, Sendable {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any Coder<Jigsaw>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(from input: String) -> (puzzle: Jigsaw, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(from: input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }

    public static func decode(from input: String, using version: Version) -> Jigsaw? {
        version.coder.decode(from: input)
    }

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    public func encode(to version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension Jigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.jigsaw) \(grid.size)" }
}
