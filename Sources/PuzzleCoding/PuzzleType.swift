//
//  PuzzleType.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/30/24.
//

enum PuzzleType: Character, CaseIterable {
    case sudoku = "S"
    case sudokuX = "X"
    case windoku = "W"

    case jigsaw = "J"

    case killerSudoku = "L"
    case killerJigsaw = "M" // TODO: verify

    case str8ts = "T"
    case kenken = "K"
    case kendoku = "D"
}
