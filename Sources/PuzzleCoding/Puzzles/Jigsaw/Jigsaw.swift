//
//  Jigsaw.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// A Jigsaw puzzle coder.
public struct Jigsaw: Equatable {
    public let boxes: [Int]
    public let grid: Grid

    public init(boxes: [Int], grid: Grid) {
        precondition(boxes.count == grid.count)
        self.boxes = boxes
        self.grid = grid
    }
}

extension Jigsaw: PuzzleCoder {
    public enum Version: CodingVersion {
        case offset

        public static var current: Version { .offset }

        fileprivate var coder: any VersionCoder<Jigsaw>.Type {
            switch self {
            case .offset: Offset.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> Jigsaw? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension Jigsaw: CustomStringConvertible {
    public var description: String { "\(PuzzleType.jigsaw) \(grid.size)" }
}
