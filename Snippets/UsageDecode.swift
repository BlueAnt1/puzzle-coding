// snippet.hide
//
//  UsageDecode.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/5/24.
//

// Decode a puzzle from an input string

import PuzzleCoding

private struct UsageDecode {
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
        var model = Model()

// snippet.show
        let input = "S9Bel0fbd01ep050eel9u…"
        // decode the input
        guard let (puzzle, version) = Sudoku.decode(input)
        else { return }

        // copy the decoded data into your model
        for (index, cell) in zip(model.indices, puzzle) {
            switch cell.content {
            case nil:
                model[index].empty = true
            case .clue(let clue):
                model[index].clue = clue
            case .solution(let solution):
                model[index].solution = solution
            case .candidates(let candidates):
                model[index].candidates = candidates
            }
        }
// snippet.hide
        let _ = version
    }
}
