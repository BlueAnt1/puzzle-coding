import Testing
@testable import PuzzleCoding

struct ShapesTests {
    @Test
    func testShapes() throws {
        // killer jigsaw cage tim tang
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
}