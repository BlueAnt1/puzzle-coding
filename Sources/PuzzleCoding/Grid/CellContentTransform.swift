//
//  CellContentTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

struct CellContentTransform {
    let size: Size

    private var solutionOffset: Int { size.valueRange.upperBound }
    private var candidatesOffset: Int { 2 * size.valueRange.upperBound }

    private var empty: Int { 0 }
    private var clueRange: ClosedRange<Int> { size.valueRange }
    private var solutionRange: ClosedRange<Int> { solutionOffset + 1 ... candidatesOffset }
    private var candidatesRange: ClosedRange<Int> { candidatesOffset + 1 ... candidatesOffset + clueRange.bitValue }
    var range: ClosedRange<Int> { empty ... candidatesRange.upperBound }

    func encode(_ content: CellContent?) -> Int {
        switch content {
        case nil: empty
        case .clue(let clue): clue
        case .solution(let solution): solution + solutionOffset
        case .candidates(let candidates): candidates.bitValue + candidatesOffset
        }
    }

    func decode(_ number: Int) throws -> CellContent? {
        switch number {
        case empty: nil
        case clueRange: .clue(number)
        case solutionRange: .solution(number - solutionOffset)
        case candidatesRange: .candidates((number - candidatesOffset).oneBits)
        default: throw CodingError.invalidCoding
        }
    }
}
