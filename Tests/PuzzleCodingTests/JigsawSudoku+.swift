//
//  KillerJigsaw+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension JigsawSudoku {
    static var andrewStuart1Example1: JigsawSudoku {
        let shapes = """
                    111222233
                    111222233
                    114452333
                    144455633
                    444555666
                    774556668
                    777956688
                    779999888
                    779999888
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let content: [CellContent?] = """
                400709020
                000020000
                090008000
                104000300
                700401002
                002000103
                000600010
                000040000
                010207045
                """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
            .map { $0 == 0 ? .candidates(Set(1...9)) : .clue($0) }

        let cells = shapes.indices.map {
            Cell(group: shapes[$0],
                 content: content[$0])
        }

        return try! JigsawSudoku(cells: cells)
    }
}
