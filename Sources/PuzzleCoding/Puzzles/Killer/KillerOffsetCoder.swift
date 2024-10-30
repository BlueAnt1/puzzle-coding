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
                \(Self.cageCoding(for: grid.size.valueRange).encode(cage))\
                \(OffsetCoder(grid: grid).rawValue)
                """
        }

        static func decode(from input: String) -> Killer? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            let cage = Reference<(Substring, (clues: [Int], shapes: [Int]))>()
            let grid = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: cage) {
                    Self.cageCoding(for: size.valueRange).arrayPattern(count: size.gridCellCount)
                } transform: {
                    var cageClues = [Int]()
                    var cageShapes = [Int]()
                    for value in $0.1 {
                        cageShapes.append((value & 0b111) + 1)
                        cageClues.append(value >> 3)
                    }
                    return ($0.0, (clues: cageClues, shapes: cageShapes))
                }
                Capture(as: grid) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Killer(cageClues: match[cage].1.clues,
                          cageShapes: match[cage].1.shapes,
                          grid: match[grid].1)
        }

        private static func cageCoding(for range: ClosedRange<Int>) -> FieldCoding {
            let maxCageClue = range.reduce(0, +) << 3
            let maxCageValue = maxCageClue + 0b111
            return FieldCoding(range: 0...maxCageValue, radix: PuzzleCoding.radix)
        }
    }
}
