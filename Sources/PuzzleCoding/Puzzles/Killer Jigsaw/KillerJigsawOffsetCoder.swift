//
//  KillerSudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension KillerJigsaw {
    struct Offset: Coder {
        static var puzzleType: PuzzleType { .killerJigsaw }
        static var version: Character { "B" }

        static func encode(_ puzzle: KillerJigsaw) -> String {
            let grid = puzzle.grid
            let shapeRanges = KillerJigsaw.shapeRanges(for: puzzle.grid.size)
            let shapes = puzzle.shapes

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(KillerCoder(size: puzzle.grid.size, shapeRanges: shapeRanges, clues: puzzle.cageClues, shapes: shapes).rawValue)\
                \(OffsetCoder(grid: grid).rawValue)
                """
        }

        static func decode(from input: String) -> KillerJigsaw? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            let cageReference = Reference<(Substring, clues: [Int], shapes: [[Int]])?>()
            let gridReference = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: cageReference) {
                    KillerPattern(size: size, shapeRanges: KillerJigsaw.shapeRanges(for: size))
                }
                Capture(as: gridReference) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...]),
                  let output = match[cageReference]
            else { return nil }

            return KillerJigsaw(cageClues: output.clues,
                                cageShapes: output.shapes[0],
                                boxShapes: output.shapes[1],
                                grid: match[gridReference].1)
        }
    }
}
