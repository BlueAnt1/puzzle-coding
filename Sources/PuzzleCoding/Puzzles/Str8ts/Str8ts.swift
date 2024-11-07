//
//  Str8ts.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// A Str8ts puzzle coder.
public struct Str8ts: Equatable {
    public let colorShapes: [Int]
    public let grid: Grid

    public init(colorShapes: [Int], grid: Grid) {
        precondition(colorShapes.count == grid.count)
        self.colorShapes = colorShapes
        self.grid = grid
    }

    static func colorRange(for size: Size) -> ClosedRange<Int> {
        0...1
    }
}

extension Str8ts: PuzzleCoder {
    public enum Version: CodingVersion {
        case versionB
        case experimental

        public static var current: Version { .versionB }

        fileprivate var coder: any VersionCoder<Str8ts>.Type {
            switch self {
            case .versionB: VersionB.self
            case .experimental: Experimental.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> Str8ts? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension Str8ts: CustomStringConvertible {
    public var description: String { "\(PuzzleType.str8ts) \(grid.size)" }
}
