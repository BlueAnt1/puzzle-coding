//
//  Str8tsVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Str8ts) -> String {
            let size = puzzle.size
            let ranges = Str8ts.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.color, ranges.cellContent)

            let cellTransform = CellContentTransform(size: size)
            let values = Zipper(
                puzzle.map(\.group!),
                puzzle.map(\.content).map(cellTransform.encode)
            ).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> Str8ts? {
            guard let header = try? HeaderPattern(sizes: Size.sudokuCases).regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = Str8ts.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.color, ranges.cellContent)
            let pattern = ShiftPattern(size: size, transform: shiftTransform)

            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let cellTransform = CellContentTransform(size: size)
                let cells = try values.map {
                    try Cell(group: $0[0],
                             content: cellTransform.decode($0[1]))
                }

                return try Str8ts(cells: cells)
            } catch {
                return nil
            }
        }
    }
}
