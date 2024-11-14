//
//  JigsawSudoku.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/16/24.
//

/// JigsawSudoku puzzle coder.
public struct JigsawSudoku: Equatable {
    public let boxShapes: [Int]
    public let grid: Grid

    public init(boxShapes: [Int], grid: Grid) {
        precondition(boxShapes.count == grid.count)
        self.boxShapes = boxShapes
        self.grid = grid
    }

    static func boxRange(in size: Size) -> ClosedRange<Int> {
        size.valueRange
    }
}

extension JigsawSudoku: PuzzleCoder {
    public enum Version: CodingVersion {
        case versionB

        public static var current: Version { .versionB }

        fileprivate var coder: any VersionCoder<JigsawSudoku>.Type {
            switch self {
            case .versionB: VersionB.self
            }
        }
    }

    public static func decode(_ input: String, using version: Version) -> JigsawSudoku? {
        version.coder.decode(input)
    }

    public func encode(using version: Version = .current) -> String {
        version.coder.encode(self)
    }
}

extension JigsawSudoku: CustomStringConvertible {
    public var description: String { "\(PuzzleType.jigsawSudoku) \(grid.size)" }
}
