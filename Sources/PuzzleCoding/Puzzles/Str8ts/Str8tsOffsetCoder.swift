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
            let grid = puzzle.grid
            let gridTransform = OffsetGridTransform(size: grid.size)
            let gridCoding = FieldCoding(range: gridTransform.range, radix: PuzzleCoding.radix)
            let colorCoding = FieldCoding(range: 0...1, radix: PuzzleCoding.radix)

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(puzzle.colors.map(colorCoding.encode).joined())\
            \(grid.map(gridTransform.encode).map(gridCoding.encode).joined())
            """
        }

        static func decode(_ input: String) -> Str8ts? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let fieldCoding = FieldCoding(range: 0...1, radix: PuzzleCoding.radix)
            let colors = Reference<(Substring, elements: [Int])>()
            let grid = Reference<(Substring, grid: Grid)>()
            let body = Regex {
                Capture(as: colors) {
                    ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
                }
                Capture(as: grid) {
                    OffsetGridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Str8ts(colors: match[colors].1, grid: match[grid].grid)
        }
    }
}
