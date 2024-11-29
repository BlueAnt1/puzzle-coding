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

    @Test
    func testShapes4() throws {
        // Double Mirror https://www.sudokuwiki.org/Jigsaw_Sudoku_Player?bd=J9B0ep0ep0ep0ep3kh1751751751750ep0060ep3kh3kh3kh1750sn1750ep55d36135t3kh35x35u5xt1750ep4qv55d6q96q96q95xt5xt0sk4qr55d4qw6q96q96q95j95xt5ja2dh55d55d6q96bn6q95xt5j61zl2s155d3yb3yf4cx3yc3ye5xt1zl2s12de2s14cx4cx4cx1zl1kz1zl2s12s12s12s14cx1ky1zl1zl1zl

        let jigsawShapes = """
                    111123333
                    111222333
                    132222213
                    133444113
                    333444111
                    133444112
                    135555512
                    111555222
                    111152222
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let shapes = try #require(Shapes(jigsawShapes))
        // every cell is covered
        #expect(shapes.reduce(into: Set<Int>()) { $0.formUnion($1.shape) }.count == jigsawShapes.count)
        // no cell is duplicated
        #expect(shapes.reduce(into: [Int]()) { $0.append(contentsOf: $1.shape) }.count == jigsawShapes.count)
        #expect(shapes.count == 9)
        #expect(shapes.allSatisfy { $0.shape.count == 9 })
        #expect(shapes.reduce(into: Set<Int>()) { $0.insert($1.color) }.count == 3)
        print(shapes)
    }
}
