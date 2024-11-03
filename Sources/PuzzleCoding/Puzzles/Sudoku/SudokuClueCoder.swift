//
//  SudokuBasicCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import Foundation

extension Sudoku {
    struct Clue: VersionCoder {
        static func encode(_ puzzle: Sudoku) -> String {
            precondition(puzzle.grid.size == .grid9x9)
            return puzzle.grid.reduce(into: "") { grid, content in
                switch content {
                case nil, .candidates:
                    grid.append(".")
                case .solution(let value), .clue(let value):
                    grid.append(String(value))
                }
            }
        }

        static func decode(_ input: String) -> Sudoku? {
            var grid = Grid(size: .grid9x9)
            var emptyCharacter: Character? = nil
            var input = input[...]
            var index = grid.startIndex

            while let character = input.first {
                input.removeFirst()
                guard !character.isWhitespace else { continue }

                switch character {
                    case "1"..."9":
                    grid[index] = .clue(character.wholeNumberValue!)
                case _ where emptyCharacter == nil:
                    emptyCharacter = character
                    break
                case emptyCharacter:
                    break
                default:
                    return nil
                }
                index = grid.index(after: index)
                guard index != grid.endIndex else { break }
            }

            guard input.trimmingCharacters(in: .whitespaces).isEmpty && index == grid.endIndex else { return nil }
            return Sudoku(grid: grid)
        }
    }
}
