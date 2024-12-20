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

    func encode(_ cell: Cell) -> Int {
        if case .solution(let solution) = cell.clue {
            solution
        } else if case .blackEmpty = cell.clue {
            blackEmpty
        } else if case .black(let clue) = cell.clue {
            clue + blackClueOffset
        } else if case .guess(let guess) = cell.progress {
            guess + guessOffset
        } else if case .candidates(let candidates) = cell.progress {
            candidates.bitValue + candidatesOffset
        } else {
            empty
        }
    }

    // partial Cell
    func decode(_ value: Int) throws -> Cell? {
        switch value {
        case empty: nil
        case clueRange: Cell(clue: .solution(value))
        case blackEmpty: Cell(clue: .blackEmpty)
        case blackClueRange: Cell(clue: .black(value - blackClueOffset))
        case guessRange: Cell(progress: .guess(value - guessOffset))
        case candidatesRange: Cell(progress: .candidates((value - candidatesOffset).oneBits))
        default: throw Error.outOfRange
        }
    }
}
