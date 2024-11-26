//
//  ShapesTests.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/25/24.
//

import Testing
//@testable import PuzzleCoding

struct ShapesTests {
    @Test
    func testShapes() throws {
        // Tim Tang killer jigsaw cage
        let elements = """
                    111221121
                    233213321
                    224413112
                    114411332
                    223332211
                    211142122
                    212244122
                    333212133
                    333212233
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let shapes = try #require(Shapes(elements))
        #expect(shapes.reduce(into: Set<Int>()) { $0.formUnion($1.shape) }.count == elements.count)
        #expect(shapes.reduce(into: [Int]()) { $0.append(contentsOf: $1.shape) }.count == elements.count)
        print(shapes)
    }

    @Test
    func testShapesLeft() throws {
        // 5x5 kenken
        let elements = """
                    12222
                    13113
                    23313
                    13112
                    14422
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let shapes = try #require(Shapes(elements))
        #expect(shapes.reduce(into: Set<Int>()) { $0.formUnion($1.shape) }.count == elements.count)
        #expect(shapes.reduce(into: [Int]()) { $0.append(contentsOf: $1.shape) }.count == elements.count)
        print(shapes)
    }

    @Test
    func testShapes3() throws {
        // Tim Tang killer jigsaw shapes
        let elements = """
                    112222233
                    112444233
                    112444233
                    116444833
                    516678839
                    556777899
                    556678899
                    556777899
                    556678899
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let shapes = try #require(Shapes(elements))
        #expect(shapes.reduce(into: Set<Int>()) { $0.formUnion($1.shape) }.count == elements.count)
        #expect(shapes.reduce(into: [Int]()) { $0.append(contentsOf: $1.shape) }.count == elements.count)
        #expect(shapes.count == 9)
        #expect(shapes.allSatisfy { $0.shape.count == 9 })
        #expect(shapes.reduce(into: Set<Int>()) { $0.insert($1.color) }.count == 3)
        print(shapes)
    }
}
