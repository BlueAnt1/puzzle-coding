//
//  KillerJigsawExperimental.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension KillerJigsaw {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .killerJigsaw }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KillerJigsaw) -> String {
            let size = puzzle.size
            let cageValues = KillerCageTransform(size: size).encode(puzzle.map(\.cage!))

            let ranges = KillerJigsaw.ranges(for: size)
            let cellTransform = CellContentTransform(size: size)
            let shiftTransform = ShiftTransform(ranges: ranges.shape,
                                                ranges.cageShape,
                                                ranges.cageContent,
                                                ranges.cellContent
            )

            let values = Zipper(
                puzzle.map(\.group!),
                puzzle.map(\.cage!.cage),
                cageValues,
                puzzle.map(\.content).map(cellTransform.encode)
            ).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KillerJigsaw? {
            guard let header = try? HeaderPattern(sizes: Size.sudokuCases).regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = KillerJigsaw.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.shape,
                                                ranges.cageShape,
                                                ranges.cageContent,
                                                ranges.cellContent)
            let pattern = ShiftPattern(size: size, transform: shiftTransform)
            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let cages = try KillerCageTransform(size: size).decode(shapes: values.map(\.[1]), contents: values.map(\.[2]))
                let cellTransform = CellContentTransform(size: size)
                let cells = try zip(cages, values).map { cage, values in
                    try Cell(group: values[0], cage: cage, content: cellTransform.decode(values[3]))
                }

                return try KillerJigsaw(cells: cells)
            } catch {
                return nil
            }
        }
    }
}
