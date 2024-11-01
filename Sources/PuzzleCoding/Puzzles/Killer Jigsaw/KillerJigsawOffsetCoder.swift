//
//  KillerSudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//
/*
import RegexBuilder

extension KillerSudoku {
    struct Offset: Coder {
        static var puzzleType: PuzzleType { .killer }
        static var version: Character { "B" }

        static func encode(_ puzzle: KillerSudoku) -> String {
            let grid = puzzle.grid

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(KillerCoder(size: puzzle.grid.size, shapeRanges: KillerSudoku.shapeRanges, clues: puzzle.cageClues, shapes: puzzle.cageShapes).rawValue)\
                \(OffsetCoder(grid: grid).rawValue)
                """
        }

        static func decode(from input: String) -> KillerSudoku? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            let cageReference = Reference<(Substring, clues: [Int], shapes: [[Int]])?>()
            let gridReference = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: cageReference) {
                    KillerPattern(size: size, shapeRanges: KillerSudoku.shapeRanges)
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
*/
