//
//  SudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct Offset: Coder {
        static var version: Character { "S" }

        static func encode(_ puzzle: Sudoku) -> String {
            """
            \(HeaderCoder(version: Self.version, boxShape: puzzle.grid.boxShape).rawValue)\
            \(OffsetCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(from input: String) -> Sudoku? {
            guard let header = try? HeaderPattern(version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let boxShape = header.output.1

            guard let coder = OffsetCoder(boxShape: boxShape, rawValue: String(input[header.range.upperBound...]))
            else { return nil }

            return Sudoku(grid: coder.grid)
        }
    }
}
