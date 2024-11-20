//
//  SudokuVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct VersionB: Coder {
        private static var version: Character { "B" }

        static func encode(_ puzzle: Sudoku) -> String {
            let cellTransform = CellContentTransform(size: puzzle.size)
            let fieldCoding = FieldCoding(range: cellTransform.range)

            return """
            \(Header(puzzleType: puzzle.type, size: puzzle.size, version: Self.version).rawValue)\
            \(puzzle.map { cellTransform.encode($0.content) }.map(fieldCoding.encode).joined())
            """
        }

        static func decode(_ input: String, type: PuzzleType) -> Sudoku? {
            guard let header = try? HeaderPattern(sizes: Size.sudokuCases).regex.prefixMatch(in: input),
                  case type = header.output.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            let cellTransform = CellContentTransform(size: size)
            let fieldCoding = FieldCoding(range: cellTransform.range)
            let pattern = ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
            guard let match = try? pattern.regex.wholeMatch(in: input[header.range.upperBound...]),
                  let content = try? match.output.elements.map(cellTransform.decode),
                  let sudoku = try? Sudoku(cells: content.map { Cell(content: $0) }, version: .versionB, type: type)
            else { return nil }
            return sudoku
        }
    }
}
