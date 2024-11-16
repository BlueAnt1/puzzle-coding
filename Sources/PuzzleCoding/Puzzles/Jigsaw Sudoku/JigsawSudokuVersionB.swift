//
//  JigsawSudokuVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension JigsawSudoku {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .jigsawSudoku }
        private static var version: Character { "B" }

        static func encode(_ puzzle: JigsawSudoku) -> String {
            let size = puzzle.size
            let ranges = JigsawSudoku.ranges(for: size)
            let cellTransform = CellContentTransform(size: size)
            let shiftTransform = ShiftTransform(ranges: ranges.boxShape, ranges.cellContent)

            let values = Zipper([
                puzzle.map(\.box!.shape),
                puzzle.map(\.content).map(cellTransform.encode)
            ]).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> JigsawSudoku? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = JigsawSudoku.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.boxShape, ranges.cellContent)
            let cellTransform = CellContentTransform(size: size)

            let pattern = ShiftPattern(size: size, transform: shiftTransform)
            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            let values = match.output.values
            do {
                let cells = try values.map {
                    try Cell(box: ($0[0], 0),   // TODO: color
                             content: cellTransform.decode($0[1]))
                }

                return try JigsawSudoku(cells: cells)
            } catch {
                return nil
            }
        }
    }
}
