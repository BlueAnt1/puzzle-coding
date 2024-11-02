//
//  SudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct Offset: Coder {
        private static var version: Character { "B" }

        static func encode(_ puzzle: Sudoku) -> String {
            """
            \(HeaderCoder(puzzleType: .sudoku(puzzle.type), size: puzzle.grid.size, version: Self.version).rawValue)\
            \(OffsetCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(from input: String) -> Sudoku? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  case .sudoku(let sudokuType) = header.output.puzzleType,
                  header.output.version == Self.version
            else { return nil }

            guard let coder = OffsetCoder(size: header.output.size, rawValue: String(input[header.range.upperBound...]))
            else { return nil }

            return Sudoku(grid: coder.grid, type: sudokuType)
        }
    }
}
