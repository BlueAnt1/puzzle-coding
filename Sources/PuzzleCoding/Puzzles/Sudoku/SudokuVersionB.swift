//
//  SudokuVersionB.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct VersionB: VersionCoder {
        private static var version: Character { "B" }

        static func encode(_ puzzle: Sudoku) -> String {
            let grid = puzzle.grid
            let transform = CellContentTransform(size: grid.size)
            let coding = FieldCoding(range: transform.range)

            return """
            \(HeaderCoder(puzzleType: .sudoku(puzzle.type), size: grid.size, version: Self.version).rawValue)\
            \(grid.map(transform.encode).map(coding.encode).joined())
            """
        }

        static func decode(_ input: String) -> Sudoku? {
            guard let header = try? HeaderPattern().regex.prefixMatch(in: input),
                  case .sudoku(let sudokuType) = header.output.puzzleType,
                  header.output.version == Self.version
            else { return nil }
            let size = header.output.size

            guard let match = try? GridPattern(size: size).regex.wholeMatch(in: input[header.range.upperBound...]) else { return nil }
            return Sudoku(grid: match.output.grid, type: sudokuType)
        }
    }
}
