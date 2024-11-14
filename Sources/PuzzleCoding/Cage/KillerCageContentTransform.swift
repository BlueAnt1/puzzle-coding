//
//  KillerCageContentTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct KillerCageContentTransform {
    let size: Size

    var clueRange: ClosedRange<Int> { 0...size.valueRange.reduce(0, +) }
    var range: ClosedRange<Int> { clueRange }

    func encode(_ content: CageContent) -> Int {
        switch content {
        case .clue(let clue) where range.contains(clue): clue
        default: fatalError()
        }
    }

    func decode(_ value: Int) throws -> CageContent {
        if range.contains(value) {
            .clue(value)
        } else {
            throw Error.outOfRange
        }
    }
}
