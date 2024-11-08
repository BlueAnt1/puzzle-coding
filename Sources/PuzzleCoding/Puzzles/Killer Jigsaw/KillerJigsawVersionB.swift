//
//  KillerJigsawVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension KillerJigsaw {
    struct VersionB: VersionCoder {
        private static var puzzleType: PuzzleType { .killerJigsaw }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KillerJigsaw) -> String {
            let grid = puzzle.grid
            let ranges = KillerJigsaw.ranges(for: grid.size)

            let shiftTransform = ShiftTransform(ranges: [ranges.cageClue, ranges.cageShape, ranges.boxShape])
            let shiftValues = Zipper([puzzle.cageClues, puzzle.cageShapes, puzzle.boxShapes]).map(shiftTransform.encode)
            let shiftCoding = FieldCoding(range: shiftTransform.range)

            let gridTransform = OffsetGridTransform(size: grid.size)
            let gridValues = grid.map(gridTransform.encode)
            let gridCoding = FieldCoding(range: gridTransform.range)

            return """
                \(HeaderCoder(puzzleType: VersionB.puzzleType, size: grid.size, version: VersionB.version).rawValue)\
                \(shiftValues.map(shiftCoding.encode).joined())\
                \(gridValues.map(gridCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KillerJigsaw? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == VersionB.puzzleType,
                  header.output.version == VersionB.version
            else { return nil }
            let size = header.output.size

            let ranges = KillerJigsaw.ranges(for: size)

            let shiftReference = Reference<(Substring, values: [[Int]])>()
            let gridReference = Reference<(Substring, grid: Grid)>()
            let body = Regex {
                Capture(as: shiftReference) {
                    ShiftPattern(size: size,
                                 ranges: [ranges.cageClue, ranges.cageShape, ranges.boxShape])
                }
                Capture(as: gridReference) {
                    OffsetGridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match[shiftReference].values

            return KillerJigsaw(cageClues: values.map { $0[0] },
                                cageShapes: values.map { $0[1] },
                                boxShapes: values.map { $0[2] },
                                grid: match[gridReference].grid)
        }
    }
}
