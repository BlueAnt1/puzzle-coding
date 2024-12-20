//
//  SudokuBasicCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import Foundation

extension Sudoku {
    struct Clue: Coder {
        static func encode(_ puzzle: Sudoku) -> String {
            precondition(puzzle.size == .grid9x9)
            return puzzle.reduce(into: "") { cells, cell in
                if case .solution(let clue) = cell.clue {
                    cells.append(String(clue))
                } else if case .guess(let guess) = cell.progress {
                    cells.append(String(guess))
                } else {
                    cells.append(".")
                }
            }
        }

        static func decode(_ input: String, type: PuzzleType) -> Sudoku? {
            var cells = Array(repeating: Cell(), count: Size.grid9x9.gridCellCount)
            var emptyCharacter: Character? = nil
            var input = input[...]
            var index = cells.startIndex

            while let character = input.first {
                input.removeFirst()
                guard !character.isWhitespace else { continue }

                switch character {
                    case "1"..."9":
                    cells[index].clue = .solution(character.wholeNumberValue!)
                case _ where emptyCharacter == nil:
                    emptyCharacter = character
                    break
                case emptyCharacter:
                    break
                default:
                    return nil
                }
                index = cells.index(after: index)
                guard index != cells.endIndex else { break }
            }

            guard input.trimmingCharacters(in: .whitespaces).isEmpty && index == cells.endIndex else { return nil }
            return try? Sudoku(cells: cells, version: .clue, type: type)
        }
    }
}
