//
//  KillerSudokuVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension KillerSudoku {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .killerSudoku }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KillerSudoku) -> String {
            let size = puzzle.size
            let cageValues = KillerCageTransform(size: size).encode(puzzle)

            let ranges = KillerSudoku.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.cageShape, ranges.cageContent, ranges.cellContent)

            let cellTransform = CellContentTransform(size: size)
            let values = Zipper(
                puzzle.map { $0.clue!.cageID! },
                cageValues,
                puzzle.map(cellTransform.encode)
            ).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KillerSudoku? {
            guard let header = try? HeaderPattern(sizes: Size.sudokuCases).regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = KillerSudoku.ranges(for: size)
            let transform = ShiftTransform(ranges: ranges.cageShape, ranges.cageContent, ranges.cellContent)
            let pattern = ShiftPattern(size: size, transform: transform)

            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let cages = try KillerCageTransform(size: size).decode(shapes: values.map(\.[0]), contents: values.map(\.[1]))
                let cellTransform = CellContentTransform(size: size)

                let cells = try zip(cages, values).map { cage, values in
                    try Cell(clue: cage, progress: cellTransform.decode(values[2]).progress)
                }

                return try KillerSudoku(cells: cells)
            } catch {
                return nil
            }
        }
    }
}
