//
//  PuzzleType.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/30/24.
//

enum PuzzleType: Character, CaseIterable {
    case jigsawSudoku = "J"
    case str8ts = "T"
    case kenken = "K"
    case kendoku = "D"
    case killerSudoku = "L"
    case killerJigsaw = "M"
    case sudoku = "S"
    case sudokuX = "X"
    case windoku = "W"
}

extension PuzzleType: CustomStringConvertible {
    var description: String {
        switch self {
        case .jigsawSudoku: String(localized: "Jigsaw Sudoku")
        case .str8ts: String(localized: "Str8ts")
        case .kenken: String(localized: "Kenken")
        case .kendoku: String(localized: "Kendoku")
        case .killerSudoku: String(localized: "Killer Sudoku")
        case .killerJigsaw: String(localized: "Killer Jigsaw")
        case .sudoku: String(localized: "Sudoku")
        case .sudokuX: String(localized: "SudokuX")
        case .windoku: String(localized: "Windoku")
        }
    }
}
