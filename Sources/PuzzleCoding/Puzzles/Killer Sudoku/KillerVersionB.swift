//
//  KillerVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension KillerSudoku {
    struct VersionB: VersionCoder {
        private static var puzzleType: PuzzleType { .killerSudoku }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KillerSudoku) -> String {
            let grid = puzzle.grid
            let gridTransform = OffsetGridTransform(size: grid.size)
            let gridCoding = FieldCoding(range: gridTransform.range)

            let ranges = KillerSudoku.ranges(for: grid.size)
            let shiftTransform = ShiftTransform(ranges: [ranges.cageClue, ranges.cageShape])
            let shiftValues = Zipper([puzzle.cageClues, puzzle.cageShapes]).map(shiftTransform.encode)
            let shiftCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(shiftValues.map(shiftCoding.encode).joined())\
                \(grid.map(gridTransform.encode).map(gridCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KillerSudoku? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size
            let maxClueValue = size.valueRange.reduce(0, +)
            let clueRange = 0...maxClueValue
            let shapeRange = 1...5
            let ranges = [clueRange, shapeRange]

            let valuesReference = Reference<(Substring, values: [[Int]])>()
            let gridReference = Reference<(Substring, grid: Grid)>()
            let body = Regex {
                Capture(as: valuesReference) {
                    ShiftPattern(size: size, ranges: ranges)
                }
                Capture(as: gridReference) {
                    OffsetGridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let output = match[valuesReference]

            return KillerSudoku(cageClues: output.values.map { $0[0] },
                                cageShapes: output.values.map { $0[1] },
                                grid: match[gridReference].grid)
        }
    }
}
