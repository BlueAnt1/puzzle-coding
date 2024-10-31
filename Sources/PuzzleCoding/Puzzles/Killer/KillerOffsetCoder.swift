//
//  KillerOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import RegexBuilder

extension Killer {
    struct Offset: Coder {
        static var puzzleType: PuzzleType { .killer }
        static var version: Character { "B" }

        static func encode(_ puzzle: Killer) -> String {
            var cage: [Int] {
                puzzle.cageClues.indices.map {
                    puzzle.cageClues[$0] << 3 + puzzle.cageShapes[$0] - 1
                }
            }

            let grid = puzzle.grid

            return """
                \(HeaderCoder(puzzleType: Self.puzzleType, size: grid.size, version: Self.version).rawValue)\
                \(CageCoder(size: puzzle.grid.size, clues: puzzle.cageClues, shapes: puzzle.cageShapes).rawValue)\
                \(OffsetCoder(grid: grid).rawValue)
                """
        }

        static func decode(from input: String) -> Killer? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            let cageReference = Reference<(Substring, clues: [Int], shapes: [Int])>()
            let gridReference = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: cageReference) {
                    CagePattern(size: size)
                }
                Capture(as: gridReference) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Killer(cageClues: match[cageReference].clues,
                          cageShapes: match[cageReference].shapes,
                          grid: match[gridReference].1)
        }
    }
}
