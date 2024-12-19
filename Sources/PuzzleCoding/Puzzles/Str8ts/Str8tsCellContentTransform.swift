//
//  CellContentTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

struct Str8tsCellContentTransform {
    let size: Size

    private var empty: Int { 0 }
    private var clueRange: ClosedRange<Int> { size.valueRange }

    private var blackEmpty: Int { clueRange.upperBound + 1 }
    private var blackClueOffset: Int { blackEmpty }
    private var guessOffset: Int { blackClueOffset + size.valueRange.upperBound }
    private var candidatesOffset: Int { blackClueOffset + 2 * size.valueRange.upperBound }

    private var blackClueRange: ClosedRange<Int> { blackClueOffset + 1 ... blackClueOffset + clueRange.upperBound }
    private var guessRange: ClosedRange<Int> { guessOffset + 1 ... candidatesOffset }
    private var candidatesRange: ClosedRange<Int> { candidatesOffset + 1 ... candidatesOffset + clueRange.bitValue }
    var range: ClosedRange<Int> { empty ... candidatesRange.upperBound }

    func encode(_ content: Cell.Content?) -> Int {
        switch content {
        case nil: empty
        case .clue(let clue): clue
        case .blackEmpty: blackEmpty
        case .blackClue(let clue): clue + blackClueOffset
        case .guess(let guess): guess + guessOffset
        case .candidates(let candidates): candidates.bitValue + candidatesOffset
        }
    }

    func decode(_ value: Int) throws -> Cell.Content? {
        switch value {
        case empty: nil
        case clueRange: .clue(value)
        case blackEmpty: .blackEmpty
        case blackClueRange: .blackClue(value - blackClueOffset)
        case guessRange: .guess(value - guessOffset)
        case candidatesRange: .candidates((value - candidatesOffset).oneBits)
        default: throw Error.outOfRange
        }
    }
}
