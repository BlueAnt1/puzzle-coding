// snippet.hide
//
//  UsageDecode.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/5/24.
//

// Encode a puzzle to an input string

import PuzzleCoding

private struct UsageEncode {
    struct Model: RandomAccessCollection {
        var startIndex: Int { 0 }
        var endIndex: Int { 0 }
        subscript(_ position: Int) -> Content {
            get { Content() }
            set {  }
        }

        struct Content {
            var empty = false
            var clue: Int? = nil
            var solution: Int? = nil
            var candidates: Set<Int>? = nil
            init() {}
            var content: CellContent? = nil
        }
    }

    func encode() {
        let model = Model()

// snippet.show
        var cells: [Cell] = []

        // copy your model data into cells
        for modelCell in model {
            let cell = Cell(content: modelCell.content)
            cells.append(cell)
        }

        if let puzzle = try? Sudoku(cells: cells) {
            // rawValue is the encoded puzzle
            let encoded = puzzle.rawValue
            print(encoded)
        }
// snippet.hide
    }
}
