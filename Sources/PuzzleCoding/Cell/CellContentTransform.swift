//
//  CellContentTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

struct CellContentTransform {
    let size: Size

    private var guessOffset: Int { size.valueRange.upperBound }
    private var candidatesOffset: Int { 2 * size.valueRange.upperBound }

    private var empty: Int { 0 }
    private var clueRange: ClosedRange<Int> { size.valueRange }
    private var guessRange: ClosedRange<Int> { guessOffset + 1 ... candidatesOffset }
    private var candidatesRange: ClosedRange<Int> { candidatesOffset + 1 ... candidatesOffset + clueRange.bitValue }
    var range: ClosedRange<Int> { empty ... candidatesRange.upperBound }

    func encode(_ content: Cell.Content?) -> Int {
        switch content {
        case nil: empty
        case .clue(let clue): clue
        case .blackEmpty, .blackClue: fatalError()
        case .guess(let guess): guess + guessOffset
        case .candidates(let candidates): candidates.bitValue + candidatesOffset
        }
    }

    func decode(_ value: Int) throws -> Cell.Content? {
        switch value {
        case empty: nil
        case clueRange: .clue(value)
        case guessRange: .guess(value - guessOffset)
        case candidatesRange: .candidates((value - candidatesOffset).oneBits)
        default: throw Error.outOfRange
        }
    }
}
