//
//  CageContentTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct KenCageContentTransform {
    let size: Size

    private var empty: Int { 0 }
    var clueRange: ClosedRange<Int> { 1...min(1023, size.valueRange.reduce(1, *)) }
    private var operatorOffset: Int { clueRange.upperBound }

    private var operatorRange: ClosedRange<Int> {
        operatorOffset + 1 ... operatorOffset
        + CageContent.Operator.allCases.map(\.rawValue).max()!
    }

    var range: ClosedRange<Int> { empty ... operatorRange.upperBound }

    func encode(_ content: CageContent?) -> Int {
        switch content {
        case nil: 0
        case .clue(let clue) where clueRange.contains(clue): clue
        case .operator(let op): op.rawValue + operatorOffset
        default: fatalError()
        }
    }

    func decode(_ value: Int) throws -> CageContent? {
        if value == 0 {
            nil
        } else if clueRange.contains(value) {
            .clue(value)
        } else if operatorRange.contains(value) {
            .operator(CageContent.Operator(rawValue: value - operatorOffset)!)
        } else {
            throw Error.outOfRange
        }
    }
}
