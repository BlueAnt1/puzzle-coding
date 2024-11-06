//
//  Str8tsOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct QCoder: VersionCoder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "Q" }

        static func encode(_ puzzle: Str8ts) -> String {
            let gridCoding = OffsetGridCoding(size: puzzle.grid.size)
            let shiftCoding = ShiftCoding(ranges: [gridCoding.range, 0...1])
            let fieldCoding = FieldCoding(range: shiftCoding.range, radix: PuzzleCoding.radix)

            let zipper = Zipper([puzzle.grid.map(gridCoding.encode), puzzle.colors])
            let coded = zipper.map(shiftCoding.encode)

//            let values = zip(puzzle.grid.map(gridCoding.encode), puzzle.colors).map { [$0.0, $0.1] }
//            let coded = values.map(shiftCoding.encode)

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(coded.map(fieldCoding.encode).joined())
            """
        }

        static func decode(_ input: String) -> Str8ts? {
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

            return Str8ts(colors: match[colors].1, grid: match[grid].1)
        }
    }
}
