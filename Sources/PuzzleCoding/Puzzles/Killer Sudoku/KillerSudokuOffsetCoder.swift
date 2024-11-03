//
//  KillerSudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension KillerSudoku {
    struct Offset: Coder {
        private static var puzzleType: PuzzleType { .killerSudoku }
        private static var version: Character { "B" }

        static func encode(_ puzzle: KillerSudoku) -> String {
            let grid = puzzle.grid
            let shapeRanges = KillerSudoku.shapeRanges(for: grid.size)
            let shapes = puzzle.shapes

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(KillerCoder(size: grid.size, shapeRanges: shapeRanges, clues: puzzle.cageClues, shapes: shapes).rawValue)\
                \(OffsetCoder(grid: grid).rawValue)
                """
        }

        static func decode(from input: String) -> KillerSudoku? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let cageReference = Reference<(Substring, clues: [Int], shapes: [[Int]])?>()
            let gridReference = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: cageReference) {
                    KillerPattern(size: size, shapeRanges: KillerSudoku.shapeRanges(for: size))
                }
                Capture(as: gridReference) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...]),
                  let output = match[cageReference]
            else { return nil }

            return KillerSudoku(cageClues: output.clues,
                                cageShapes: output.shapes[0],
                                grid: match[gridReference].1)
        }
    }
}
