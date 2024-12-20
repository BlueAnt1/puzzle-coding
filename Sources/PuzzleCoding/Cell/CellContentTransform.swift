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

    func encode(_ cell: Cell) -> Int {
        if case .solution(let clue) = cell.clue {
            clue
        } else if case .guess(let guess) = cell.progress {
            guess + guessOffset
        } else if case .candidates(let candidates) = cell.progress {
            candidates.bitValue + candidatesOffset
        } else {
            empty
        }
    }

    // partial cell
    func decode(_ value: Int) throws -> Cell {
        switch value {
        case empty: Cell()
        case clueRange: Cell(clue: .solution(value))
        case guessRange: Cell(progress: .guess(value - guessOffset))
        case candidatesRange: Cell(progress: .candidates((value - candidatesOffset).oneBits))
        default: throw Error.outOfRange
        }
    }
}
