//
//  CellContentTransformTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/26/24.
//

@testable import PuzzleCoding
import Testing

struct CellContentTransformTransformTests {
    @Test
    func encode() {
        let size = Size.grid9x9
        let transform = CellContentTransform(size: size)
        #expect(transform.encode(.clue(1)) == 1)
        #expect(transform.encode(.clue(9)) == 9)
        #expect(transform.encode(.guess(1)) == 10)
        #expect(transform.encode(.guess(9)) == 18)
        #expect(transform.encode(.candidates([1])) == 19)
        #expect(transform.encode(.candidates(Set(size.valueRange))) == 529)
    }

    @Test
    func decode() throws {
        let size = Size.grid9x9
        let transform = CellContentTransform(size: size)
        #expect(try transform.decode(1) == .clue(1))
        #expect(try transform.decode(9) == .clue(9))
        #expect(try transform.decode(10) == .guess(1))
        #expect(try transform.decode(18) == .guess(9))
        #expect(try transform.decode(19) == .candidates([1]))
        #expect(try transform.decode(529) == .candidates(Set(size.valueRange)))
    }
}
