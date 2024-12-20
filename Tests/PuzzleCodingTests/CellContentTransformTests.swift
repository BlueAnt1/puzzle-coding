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
        #expect(transform.encode(Cell(clue: .solution(1))) == 1)
        #expect(transform.encode(Cell(clue: .solution(9))) == 9)
        #expect(transform.encode(Cell(content: .guess(1))) == 10)
        #expect(transform.encode(Cell(content: .guess(9))) == 18)
        #expect(transform.encode(Cell(content: .candidates([1]))) == 19)
        #expect(transform.encode(Cell(content: .candidates(Set(size.valueRange)))) == 529)
    }

    @Test
    func decode() throws {
        let size = Size.grid9x9
        let transform = CellContentTransform(size: size)
        #expect(try transform.decode(1) == Cell(clue: .solution(1)))
        #expect(try transform.decode(9) == Cell(clue: .solution(9)))
        #expect(try transform.decode(10) == Cell(content: .guess(1)))
        #expect(try transform.decode(18) == Cell(content: .guess(9)))
        #expect(try transform.decode(19) == Cell(content: .candidates([1])))
        #expect(try transform.decode(529) == Cell(content: .candidates(Set(size.valueRange))))
    }
}
