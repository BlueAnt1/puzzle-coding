//
//  SudokuOffsetCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct Offset: Coder {
        static var puzzleType: PuzzleType { .sudoku }
        static var version: Character { "B" }

        static func encode(_ puzzle: Sudoku) -> String {
            """
            \(HeaderCoder(puzzleType: .sudoku, size: puzzle.grid.size, version: Self.version).rawValue)\
            \(OffsetCoder(grid: puzzle.grid).rawValue)
            """
        }

        static func decode(from input: String) -> Sudoku? {
            guard let header = try? HeaderPattern(puzzleType: Self.puzzleType, version: Self.version).regex.prefixMatch(in: input)
            else { return nil }
            let size = header.output.1

            guard let coder = OffsetCoder(size: size, rawValue: String(input[header.range.upperBound...]))
            else { return nil }

            return Sudoku(grid: coder.grid)
        }
    }
}
