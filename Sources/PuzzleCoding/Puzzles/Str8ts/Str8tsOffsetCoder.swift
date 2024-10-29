//
//  Str8tsOffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct Offset: Coder {
        static var version: Character { "8" }

        static func encode(_ puzzle: Str8ts) -> String {
            """
            \(HeaderCoder(version: Self.version, boxShape: puzzle.grid.boxShape).rawValue)\
            \(FieldCoding(range: 0...1, radix: PuzzleCoding.radix).encode(puzzle.colors))\
            \(OffsetCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(from input: String) -> Str8ts? {
            guard let header = try? HeaderPattern(version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let boxShape = header.output.1

            let colors = Reference<(Substring, [Int])>()
            let grid = Reference<(Substring, Grid)>()
            let body = Regex {
                Capture(as: colors) {
                    FieldCoding(range: 0...1, radix: PuzzleCoding.radix).arrayPattern(count: boxShape.size.gridCellCount)
                }
                Capture(as: grid) {
                    OffsetPattern(boxShape: boxShape)
                }
            }

            guard let match = try? body.wholeMatch(in: input[header.range.upperBound...])
            else { return nil }

            return Str8ts(colors: match[colors].1, grid: match[grid].1)
        }
    }
}
