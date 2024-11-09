//
//  Str8tsVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct VersionB: VersionCoder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Str8ts) -> String {
            let grid = puzzle.grid
            let cellTransform = CellContentTransform(size: grid.size)
            let gridCoding = FieldCoding(range: cellTransform.range)
            let colorCoding = FieldCoding(range: 0...1)

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(puzzle.colorShapes.map(colorCoding.encode).joined())\
            \(grid.map(cellTransform.encode).map(gridCoding.encode).joined())
            """
        }

        static func decode(_ input: String) -> Str8ts? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let fieldCoding = FieldCoding(range: 0...1)
            let colors = Reference<(Substring, elements: [Int])>()
            let grid = Reference<(Substring, grid: Grid)>()
            let body = Regex {
                Capture(as: colors) {
                    ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
                }
                Capture(as: grid) {
                    GridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Str8ts(colorShapes: match[colors].1, grid: match[grid].grid)
        }
    }
}