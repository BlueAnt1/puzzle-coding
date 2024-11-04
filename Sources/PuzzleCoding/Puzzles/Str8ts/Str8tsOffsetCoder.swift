//
//  Str8tsOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct Offset: VersionCoder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Str8ts) -> String {
            let fieldCoding = FieldCoding(range: 0...1, radix: PuzzleCoding.radix)

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(puzzle.colors.map(fieldCoding.encode).joined())\
            \(OffsetGridCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(_ input: String) -> Str8ts? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let colors = Reference<(Substring, values: [Int])>()
            let grid = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: colors) {
                    ArrayPattern(count: size.gridCellCount, range: 0...1, radix: PuzzleCoding.radix)
                }
                Capture(as: grid) {
                    OffsetGridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Str8ts(colors: match[colors].1, grid: match[grid].1)
        }
    }
}
