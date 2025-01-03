//
//  KillerSudoku+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension KillerSudoku {
    static var gentleExample1: KillerSudoku {
        let cageShapes = """
                        112211211
                        112122333
                        231131231
                        212331221
                        212441321
                        121141341
                        133233142
                        133244132
                        131113332
                        """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let operators = [24,  0,  6,  0, 17,  0,  2, 10,  0,
                     0,  0,  0, 12, 10,  0, 23,  0,  0,
                     16,  8,  0,  0, 10, 20, 18,  0, 23,
                     0,  7, 16,  0,  0,  0,  0,  0,  0,
                     0,  0,  0, 20,  0,  0, 10,  0,  0,
                     19,  6,  7,  0,  0,  0,  0, 12,  0,
                     0, 24,  0, 15,  4,  0,  5,  0, 11,
                     0,  0,  0,  0, 12,  0,  0, 25,  0,
                     0,  0, 13,  0,  0,  0,  0,  0,  0].map { $0 == 0 ? nil : Clue.Operator.add($0) }
        // SudokuWiki sends a single cage clue as a solved cell
        let content = "000000200000000000080000000000000000000000000060000000000000000000000000000000000"
            .map(\.wholeNumberValue!)
            .map { $0 == 0 ? Progress.candidates(Set(1...9)) : Progress.guess($0) }

        let cells = cageShapes.indices.map { index in
            Cell(clue: .cage(id: cageShapes[index], operator: operators[index]), progress: content[index])
        }

        return try! KillerSudoku(cells: cells)
    }
}
