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
        subscript(_ position: Int) -> Any? {
            get { nil }
            set {  }
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
        for (index, content) in zip(model.indices, puzzle.grid) {
            switch content {
            case nil:
                model[index] = "empty"
            case .clue(let clue):
                model[index] = clue
            case .solution(let solution):
                model[index] = solution
            case .candidates(let candidates):
                model[index] = candidates
            }
        }
// snippet.hide
        let _ = version
    }
}
