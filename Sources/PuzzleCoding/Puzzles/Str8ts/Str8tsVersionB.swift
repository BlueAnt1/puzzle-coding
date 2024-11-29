//
//  Str8tsVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

extension Str8ts {
    struct VersionB: Coder {
        private static var puzzleType: PuzzleType { .str8ts }
        private static var version: Character { "B" }

        static func encode(_ puzzle: Str8ts) -> String {
            let size = puzzle.size

            let cellTransform = Str8tsCellContentTransform(size: size)
            let values = puzzle.map(\.content).map(cellTransform.encode)
            let fieldCoding = FieldCoding(range: cellTransform.range)

            return """
                \(Header(puzzleType: Self.puzzleType, size: size, version: Self.version).rawValue)\
                \(values.map(fieldCoding.encode).joined())
                """
        }

        static func decode(_ input: String, type: PuzzleType) -> Str8ts? {
            guard let header = try? HeaderPattern(sizes: Size.sudokuCases).regex.prefixMatch(in: input),
                  header.output.puzzleType == Self.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let cellTransform = Str8tsCellContentTransform(size: size)
            let fieldCoding = FieldCoding(range: cellTransform.range)
            let pattern = ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)

            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...]),
                  let content = try? match.output.elements.map(cellTransform.decode),
                  let puzzle = try? Str8ts(cells: content.map { Cell(content: $0) }, version: .versionB, type: type)
            else { return nil }
            return puzzle
        }
    }
}
