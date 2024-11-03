//
//  PuzzleType.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/30/24.
//

enum PuzzleType {
    case jigsaw
    case str8ts
    case kenken
    case kendoku
    case killerSudoku
    case killerJigsaw
    case sudoku(SudokuType)

    enum SudokuType: Character, CaseIterable {
        case sudoku = "S"
        case sudokuX = "X"
        case windoku = "W"
    }
}

extension PuzzleType: CaseIterable {
    static var allCases: [PuzzleType] {
        [.jigsaw, .str8ts, .kenken, .kendoku, .killerSudoku, .killerJigsaw]
        + SudokuType.allCases.map { .sudoku($0) }
    }
}

extension PuzzleType: RawRepresentable {
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
}

extension PuzzleType.SudokuType: CustomStringConvertible {
    var description: String {
        switch self {
        case .sudoku: String(localized: "Sudoku")
        case .sudokuX: String(localized: "SudokuX")
        case .windoku: String(localized: "Windoku")
        }
    }
}

extension PuzzleType: CustomStringConvertible {
    var description: String {
        switch self {
        case .jigsaw: String(localized: "Jigsaw")
        case .str8ts: String(localized: "Str8ts")
        case .kenken: String(localized: "Kenken")
        case .kendoku: String(localized: "Kendoku")
        case .killerSudoku: String(localized: "Killer Sudoku")
        case .killerJigsaw: String(localized: "Killer Jigsaw")
        case .sudoku(let type): type.description
        }
    }
}
