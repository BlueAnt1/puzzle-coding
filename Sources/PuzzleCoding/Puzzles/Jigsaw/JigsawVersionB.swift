//
//  JigsawVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Jigsaw {
    struct VersionB: VersionCoder {
        private static var puzzleType: PuzzleType { .jigsawSudoku }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Jigsaw) -> String {
            let grid = puzzle.grid
            let cellTransform = CellContentTransform(size: grid.size)
            let gridCoding = FieldCoding(range: cellTransform.range)
            let boxCoding = FieldCoding(range: Jigsaw.boxRange(in: grid.size))

            return """
                \(Header(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(puzzle.boxShapes.map(boxCoding.encode).joined())\
                \(grid.map(cellTransform.encode).map(gridCoding.encode).joined())
                """
        }

        static func decode(_ input: String) -> Jigsaw? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let boxCoding = FieldCoding(range: Jigsaw.boxRange(in: size))
            let boxShapes = Reference<(Substring, elements: [Int])>()
            let grid = Reference<GridPattern.RegexOutput>()
            let body = Regex {
                Capture(as: boxShapes) {
                    ArrayPattern(repeating: boxCoding.pattern, count: size.gridCellCount)
                }
                Capture(as: grid) {
                    GridPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Jigsaw(boxShapes: match[boxShapes].1, grid: match[grid].1)
        }
    }
}
