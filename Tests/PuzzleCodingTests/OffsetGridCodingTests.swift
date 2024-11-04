//
//  OffsetGridCodingTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/26/24.
//

@testable import PuzzleCoding
import Testing

struct OffsetGridCodingTests {
    @Test
    func encode() {
        let size = Size.grid9x9
        let offsetCoding = OffsetGridCoding(size: size)
        #expect(offsetCoding.encode(.clue(1)) == 1)
        #expect(offsetCoding.encode(.clue(9)) == 9)
        #expect(offsetCoding.encode(.solution(1)) == 10)
        #expect(offsetCoding.encode(.solution(9)) == 18)
        #expect(offsetCoding.encode(.candidates([1])) == 19)
        #expect(offsetCoding.encode(.candidates(Set(size.valueRange))) == 529)
    }

    @Test
    func decode() throws {
        let size = Size.grid9x9
        let offsetCoding = OffsetGridCoding(size: size)
        #expect(try offsetCoding.decode(1) == .clue(1))
        #expect(try offsetCoding.decode(9) == .clue(9))
        #expect(try offsetCoding.decode(10) == .solution(1))
        #expect(try offsetCoding.decode(18) == .solution(9))
        #expect(try offsetCoding.decode(19) == .candidates([1]))
        #expect(try offsetCoding.decode(529) == .candidates(Set(size.valueRange)))
    }
}
