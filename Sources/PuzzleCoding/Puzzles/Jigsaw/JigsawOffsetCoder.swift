//
//  JigsawOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Jigsaw {
    struct Offset: Coder {
        static var version: Character { "J" }

        static func encode(_ puzzle: Jigsaw) -> String {
        """
        \(HeaderCoder(version: Self.version, boxShape: puzzle.grid.boxShape).rawValue)\
        \(FieldCoding(range: puzzle.grid.size.valueRange, radix: PuzzleCoding.radix).encode(puzzle.boxes))\
        \(OffsetCoder(grid: puzzle.grid).rawValue)
        """
        }

        static func decode(from input: String) -> Jigsaw? {
            guard let header = try? HeaderPattern(version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let boxShape = header.output.1
            let size = boxShape.size

            let boxes = Reference<(Substring, [Int])>()
            let grid = Reference<OffsetPattern.RegexOutput>()
            let body = Regex {
                Capture(as: boxes) {
                    FieldCoding(range: size.valueRange, radix: PuzzleCoding.radix).arrayPattern(count: size.gridCellCount)
                }
                Capture(as: grid) {
                    OffsetPattern(boxShape: boxShape)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Jigsaw(boxes: match[boxes].1, grid: match[grid].1)
        }
    }
}
