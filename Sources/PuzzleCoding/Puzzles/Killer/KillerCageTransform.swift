//
//  KillerCageTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct KillerCageTransform {
    let size: Size

    var empty: Int { 0 }
    var clueRange: ClosedRange<Int> { 1...size.valueRange.reduce(0, +) }
    var range: ClosedRange<Int> { empty...clueRange.upperBound }

    func encode(_ cells: some Collection<Cell>) -> [Int] {
        cells.map { cell in
            if case .cage(id: _, operator: let op?) = cell.clue {
                op.operand
            } else {
                empty
            }
        }
    }

    // partial cell
    func decode(shapes: [Int], contents: [Int]) throws -> [Clue] {
        try zip(shapes, contents).map { cage, content in
            if content == empty {
                .cage(id: cage, operator: nil)
            } else if clueRange.contains(content) {
                .cage(id: cage, operator: .add(content))
            } else {
                throw Error.outOfRange
            }
        }
    }
}
