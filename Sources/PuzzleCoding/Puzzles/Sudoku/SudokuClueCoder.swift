//
//  SudokuBasicCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct Clue: Coder {
        static func encode(_ puzzle: Sudoku) -> String {
            puzzle.grid.reduce(into: "") { grid, content in
                switch content {
                case nil, .candidates:
                    grid.append(".")
                case .solution(let value), .clue(let value):
                    grid.append(String(value))
                }
            }
        }

        static func decode(from input: String) -> Sudoku? {
            var content = [CellContent?]()
            var emptyCharacter: Character? = nil

            for character in input where !character.isWhitespace {
                switch character {
                    case "1"..."9":
                    content.append(.clue(character.wholeNumberValue!))
                case _ where emptyCharacter == nil:
                    emptyCharacter = character
                    fallthrough
                case emptyCharacter:
                    content.append(nil)
                default:
                    return nil
                }
            }

            guard let grid = Grid(size: .grid9x9, content: content) else { return nil }
            return Sudoku(grid: grid)
        }
    }
}
