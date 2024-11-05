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
            var cellContent: CellContent? = nil
        }
    }

    func encode() {
        let model = Model()

// snippet.show
        var grid = Grid()

        // copy your model data into the grid
        for index in grid.indices {
            grid[index] = model[index].cellContent
        }

        let coder = Sudoku(grid: grid)
        // encode the puzzle to text
        let encoded = coder.encode()
// snippet.hide
        let _ = encoded
    }
}
