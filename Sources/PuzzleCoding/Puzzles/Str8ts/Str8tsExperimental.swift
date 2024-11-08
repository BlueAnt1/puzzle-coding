//
//  Str8tsExperimental.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct Experimental: VersionCoder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "X" }

        static func encode(_ puzzle: Str8ts) -> String {
            let grid = puzzle.grid
            let gridTransform = OffsetGridTransform(size: grid.size)
            let ranges = [Str8ts.colorRange(for: grid.size), gridTransform.range]
            let shiftTransform = ShiftTransform(ranges: ranges)
            let fieldCoding = FieldCoding(range: shiftTransform.range)

            let zipper = Zipper([puzzle.colorShapes, puzzle.grid.map(gridTransform.encode)])
            let shiftValues = zipper.map(shiftTransform.encode)

            return """
            \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(shiftValues.map(fieldCoding.encode).joined())
            """
        }

        static func decode(_ input: String) -> Str8ts? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let gridTransform = OffsetGridTransform(size: size)
            let ranges = [Str8ts.colorRange(for: size), gridTransform.range]
            guard let match = try? ShiftPattern(size: size, ranges: ranges).regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let content = try values.map { try gridTransform.decode($0[1]) }
                guard let grid = Grid(content) else { return nil }
                return Str8ts(colorShapes: values.map { $0[0] }, grid: grid)
            } catch {
                return nil
            }
        }
    }
}
