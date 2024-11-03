//
//  Str8ts.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

public struct Str8ts: Equatable {
    public let colors: [Int]
    public let grid: Grid

    public init(colors: [Int], grid: Grid) {
        precondition(colors.count == grid.count)
        self.colors = colors
        self.grid = grid
    }
}

extension Str8ts: PuzzleCoder {
    public enum Version: VersionProtocol {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any VersionCoder<Str8ts>.Type {
            switch self {
            case .offset: Offset.self
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
