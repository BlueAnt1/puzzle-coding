//
//  KenKenVersionB.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/15/24.
//

import RegexBuilder

extension KenKen {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .kenken }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KenKen) -> String {
            let size = puzzle.size
            let ranges = KenKen.ranges(for: size)
            let shiftTransform = ShiftTransform(ranges: [
                ranges.cageShape,
                ranges.cageContent,
                ranges.cellContent
            ])

            let cageTransform = KenCageContentTransform(size: size)
            let cellTransform = CellContentTransform(size: size)
            let values = Zipper([
                puzzle.map(\.cage!.shape),
                puzzle.map(\.cage!.content).map(cageTransform.encode),
                puzzle.map(\.content).map(cellTransform.encode)
            ]).map(shiftTransform.encode)

            let fieldCoding = FieldCoding(range: shiftTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> KenKen? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let ranges = KenKen.ranges(for: size)
            let pattern = ShiftPattern(size: size,
                                       ranges: [
                                        ranges.cageShape,
                                        ranges.cageContent,
                                        ranges.cellContent
                                       ])

            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }
            let values = match.output.values

            do {
                let cageTransform = KenCageContentTransform(size: size)
                let cellTransform = CellContentTransform(size: size)
                let cells = try values.map {
                    try Cell(cage: (shape: $0[0], content: cageTransform.decode($0[1])),
                             content: cellTransform.decode($0[2]))
                }

                return try KenKen(cells: cells)
            } catch {
                return nil
            }
        }
    }
}
