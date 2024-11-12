//
//  CageContentTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct CageContentTransform {
    let size: Size

    private var clueRange: ClosedRange<Int> { 1...size.valueRange.reduce(0, +) }
    private var operatorOffset: Int { clueRange.upperBound }
    private var operatorRange: ClosedRange<Int> { operatorOffset + 1 ... operatorOffset + CageContent.Operator.allCases.map(\.rawValue).max()! }
    var range: ClosedRange<Int> { clueRange.lowerBound ... operatorRange.upperBound }

    func encode(_ content: CageContent) -> Int {
        switch content {
        case .clue(let clue): clue
        case .operator(let op): op.rawValue + operatorOffset
        }
    }

    func decode(_ value: Int) throws -> CageContent {
        switch value {
        case clueRange: .clue(value)
        case operatorRange: .operator(CageContent.Operator(rawValue: value - operatorOffset)!)
        default: throw Error.outOfRange
        }
    }
}
