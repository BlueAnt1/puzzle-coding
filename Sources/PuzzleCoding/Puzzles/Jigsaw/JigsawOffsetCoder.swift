//
//  JigsawOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Jigsaw {
    struct Offset: Coder {
        private static var puzzleType: PuzzleType { .jigsaw }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Jigsaw) -> String {
        """
        \(HeaderCoder(puzzleType: Self.puzzleType, size: puzzle.grid.size, version: Self.version).rawValue)\
        \(FieldCoding(range: puzzle.grid.size.valueRange, radix: PuzzleCoding.radix).encode(puzzle.boxes))\
        \(OffsetCoder(grid: puzzle.grid).rawValue)
        """
        }

        static func decode(from input: String) -> Jigsaw? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let boxes = Reference<(Substring, values: [Int])>()
            let grid = Reference<OffsetPattern.RegexOutput>()
            let body = Regex {
                Capture(as: boxes) {
                    FieldCoding(range: size.valueRange, radix: PuzzleCoding.radix).arrayPattern(count: size.gridCellCount)
                }
                Capture(as: grid) {
                    OffsetPattern(size: size)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Jigsaw(boxes: match[boxes].1, grid: match[grid].1)
        }
    }
}
