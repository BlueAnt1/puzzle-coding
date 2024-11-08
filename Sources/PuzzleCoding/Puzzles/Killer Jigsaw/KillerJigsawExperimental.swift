//
//  KillerJigsawExperimental.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension KillerJigsaw {
    struct Experimental: VersionCoder {
        private static var puzzleType: PuzzleType { .killerJigsaw }
        private static var version: Character { "X" }

        static func encode(_ puzzle: KillerJigsaw) -> String {
            let grid = puzzle.grid
            let jigsawRanges = KillerJigsaw.ranges(for: grid.size)

            let cellTransform = CellContentTransform(size: grid.size)
            let shiftTransform = ShiftTransform(ranges: [
                jigsawRanges.cageClue,
                jigsawRanges.cageShape,
                jigsawRanges.boxShape,
                cellTransform.range
            ])

            let values = Zipper([
                puzzle.cageClues,
                puzzle.cageShapes,
                puzzle.boxShapes,
                grid.map(cellTransform.encode)
            ]).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KillerJigsaw? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let jigsawRanges = KillerJigsaw.ranges(for: size)
            let cellTransform = CellContentTransform(size: size)

            let body = Regex {
                Capture {
                    ShiftPattern(size: size,
                                 ranges: [jigsawRanges.cageClue,
                                          jigsawRanges.cageShape,
                                          jigsawRanges.boxShape,
                                          cellTransform.range])
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.1.values

            do {
                let content = try values.map { try cellTransform.decode($0[3]) }
                guard let grid = Grid(content) else { return nil }
                return KillerJigsaw(cageClues: values.map { $0[0] },
                                    cageShapes: values.map { $0[1] },
                                    boxShapes: values.map { $0[2] },
                                    grid: grid)
            } catch {
                return nil
            }
        }
    }
}
