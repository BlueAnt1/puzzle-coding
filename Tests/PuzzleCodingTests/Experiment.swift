//
//  Experiment.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/8/24.
//

import Testing
@testable import PuzzleCoding

struct Experiment {

    @Test
    func noOptimization () {
        let sizes = Size.allCases   // [Size.grid9x9]
        let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
        for size in sizes {
            let puzzle = Puzzle(size: size)
            for type in puzzles {
                let ranges = type.requirements.map { puzzle.ranges[$0]! }
                let transform = ShiftTransform(ranges: ranges)
                let bitCount = String(transform.range.upperBound, radix: 2).count
                let fieldWidth = String(transform.range.upperBound, radix: PuzzleCoding.radix).count
                print(size, type, transform.range, bitCount, fieldWidth, separator: "\t")
            }
        }
    }

    enum PuzzleType: CaseIterable {
        typealias Requirement = KeyPath<Puzzle, [Int]?>
        typealias Requirements = [Requirement]

        case kendoku, kenken, killerJigsaw, killerSudoku, jigsawSudoku, sudoku

        var requirements: Requirements {
            switch self {
            case .kendoku: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .kenken: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .killerJigsaw: [\.boxShapes, \.cageClues, \.cageShapes, \.progress]
            case .killerSudoku: [\.cageClues, \.cageShapes, \.progress]
            case .jigsawSudoku: [\.clues, \.boxShapes, \.progress]
            case .sudoku: [\.clues, \.progress]
            }
        }
    }

    struct Puzzle {
        let size: Size
        var clues: [Int]? = nil
        var boxShapes: [Int]? = nil
        var cageClues: [Int]? = nil
        var cageShapes: [Int]? = nil
        var clueOperator: [Int]? = nil
        var progress: [Int]? = nil

        var ranges: [KeyPath<Puzzle, [Int]?> : ClosedRange<Int>] {
            [
                \.clues: 0...size.valueRange.upperBound,
                 \.boxShapes: size.valueRange,
                 \.cageClues: 0...size.valueRange.reduce(0, +),
                 \.cageShapes: 1...5,
                 \.clueOperator: 1...4,
                 \.progress: 0...(size.valueRange.upperBound + size.valueRange.bitValue)    // solution & candidates
            ]
        }
    }
}
