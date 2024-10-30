//
//  Str8tsOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct Offset: Coder {
        static var puzzleType: PuzzleType { .str8ts }
        static var version: Character { "B" }

        static func encode(_ puzzle: Str8ts) -> String {
            """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(FieldCoding(range: 0...1, radix: PuzzleCoding.radix).encode(puzzle.colors))\
            \(OffsetCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(from input: String) -> Str8ts? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            let colors = Reference<(Substring, [Int])>()
            let grid = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: colors) {
                    FieldCoding(range: 0...1, radix: PuzzleCoding.radix).arrayPattern(count: size.gridCellCount)
                }
                Capture(as: grid) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Str8ts(colors: match[colors].1, grid: match[grid].1)
        }
    }
}
