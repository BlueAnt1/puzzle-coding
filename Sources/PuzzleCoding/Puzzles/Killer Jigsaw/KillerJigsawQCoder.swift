//
//  Str8tsOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension KillerJigsaw {
    struct QCoder: VersionCoder {
        private static var puzzleType: PuzzleType { .killerJigsaw }
        private static var version: Character { "Q" }

        static func encode(_ puzzle: KillerJigsaw) -> String {
            let grid = puzzle.grid
            let gridCoding = OffsetGridCoding(size: grid.size)

            let clues = puzzle.cageClues
            let clueRange = 0...grid.size.valueRange.reduce(0, +)

            let shapes = puzzle.shapes  // cageShapes: 1...5, boxShapes: size.valueRange
            let shapeRanges = KillerJigsaw.shapeRanges(for: grid.size)

            let shiftCoding = ShiftCoding(ranges: [gridCoding.range, clueRange] + shapeRanges)
            let fieldCoding = FieldCoding(range: shiftCoding.range, radix: PuzzleCoding.radix)

            let coded = Zipper([grid.map(gridCoding.encode), clues] + shapes)
                .map(shiftCoding.encode)
                .map(fieldCoding.encode)
                .joined()

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(coded)
            """
        }

        static func decode(_ input: String) -> KillerJigsaw? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let fieldCoding = FieldCoding(range: 0...1, radix: PuzzleCoding.radix)
            let colors = Reference<(Substring, values: [Int])>()
            let grid = Reference<(Substring, Grid)>()
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

            return nil
            //return KillerJigsaw(colors: match[colors].1, grid: match[grid].1)
        }
    }
}
