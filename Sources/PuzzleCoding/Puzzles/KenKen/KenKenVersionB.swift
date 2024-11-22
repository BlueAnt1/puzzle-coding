//
//  KenKenVersionB.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/15/24.
//

import RegexBuilder



extension KenKen {
    struct VersionB: Coder {
        private static var version: Character { "B" }

        static func encode(_ puzzle: KenKen) -> String {
            let size = puzzle.size

            let cageContent = KenCageTransform(size: size).encode(puzzle.map(\.cage!))
            let ranges = KenKen.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: ranges.cageShape, ranges.cageContent, ranges.cellContent)

            let cellTransform = CellContentTransform(size: size)
            let values = Zipper(
                puzzle.map(\.cage!.cage),
                cageContent,
                puzzle.map(\.content).map(cellTransform.encode)
            ).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: puzzle.type, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String, type: PuzzleType) -> KenKen? {
            guard let header = try? HeaderPattern(sizes: Size.kenCases).regex.prefixMatch(in: input),
                  case type = header.output.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = KenKen.ranges(for: size)
            let transform = ShiftTransform(ranges: ranges.cageShape, ranges.cageContent, ranges.cellContent)
            let pattern = ShiftPattern(size: size, transform: transform)

            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let cages = try KenCageTransform(size: size).decode(shapes: values.map(\.[0]),
                                                                    contents: values.map(\.[1]))

                let cellTransform = CellContentTransform(size: size)
                let cells = try zip(cages, values).map { cage, values in
                    try Cell(cage: cage, content: cellTransform.decode(values[2]))
                }

                return try KenKen(cells: cells, version: .versionB, type: type)
            } catch {
                return nil
            }
        }
    }
}
