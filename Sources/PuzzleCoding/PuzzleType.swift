//
//  PuzzleType.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/30/24.
//

enum PuzzleType: CaseIterable, RawRepresentable {
    case jigsaw
    case str8ts
    case kenken
    case kendoku
    case killerSudoku
    case killerJigsaw
    case sudoku(SudokuType)

    init?(rawValue: Character) {
        switch rawValue {
        case "J": self = .jigsaw
        case "T": self = .str8ts
        case "K": self = .kenken
        case "D": self = .kendoku
        case "L": self = .killerSudoku
        case "M": self = .killerJigsaw
        default:
            if let sudoku = SudokuType(rawValue: rawValue) {
                self = .sudoku(sudoku)
            } else {
                return nil
            }
        }
    }

    var rawValue: Character {
        switch self {
        case .jigsaw: "J"
        case .str8ts: "T"
        case .kenken: "K"
        case .kendoku: "D"
        case .killerSudoku: "L"
        case .killerJigsaw: "M"
        case .sudoku(let type): type.rawValue
        }
    }

    static var allCases: [PuzzleType] {
        [.jigsaw, .str8ts, .kenken, .kendoku, .killerSudoku, .killerJigsaw]
        + SudokuType.allCases.map {.sudoku($0) }
    }

    enum SudokuType: Character, CaseIterable {
        case sudoku = "S"
        case sudokuX = "X"
        case windoku = "W"
    }
}

