//
//  Shapes.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/24/24.
//

import Testing
@testable import PuzzleCoding

private struct Shapes {
    private let elements: [Int]

    init(_ elements: [Int]) {
        assert(Size(gridCellCount: elements.count) != nil)
        self.elements = elements
    }

    var shapesAndNeighbors: [(shape: Shape, neighbors: Set<Int>)] {
        let size = Size(gridCellCount: elements.count)!
        var remaining = Set(elements.indices)

        func shapeAndNeighbors(of index: Int) -> (Set<Int>, Set<Int>) {
            let up = index - size.rawValue >= 0 ? index - size.rawValue : nil
            let down = index + size.rawValue < elements.endIndex ? index + size.rawValue : nil
            let left = index % size.rawValue > 0 ? index - 1 : nil
            let right = index % size.rawValue < size.rawValue - 1 ? index + 1 : nil
            let mates = [up, down, left, right].compactMap(\.self)
            let shapeMates = mates.filter { elements[$0] == elements[index] }//.filter(remaining.contains)

            var neighbors = Set(mates.filter { !shapeMates.contains($0) })
            var shape = Set([index] + shapeMates)

            remaining.subtract([index])
            for sm in shapeMates where remaining.contains(sm) {
                let (s, n) = shapeAndNeighbors(of: sm)
                shape.formUnion(s)
                neighbors.formUnion(n)
                remaining.subtract(s)
            }

            return (shape, neighbors)
        }

        var shapes: [(shape: Shape, neighbors: Set<Int>)] = []

        for index in elements.indices where remaining.contains(index) {
            shapes.append(shapeAndNeighbors(of: index))
        }

        // (shape: set of cell indices, neighbors: set of neighboring cell indices, make them set of neighboring shape indices)
        for index in shapes.indices {
            shapes[index].neighbors = Set(shapes[index].neighbors.map { neighborCell in shapes.firstIndex { $0.shape.contains(neighborCell) }!})
        }

        return shapes
    }

    typealias Shape = Set<Int>
    typealias ColoredShape = (shape: Shape, color: Int)

}

struct TestShapes {
    @Test
    func testShapes() throws {
        // killer jigsaw cage
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
        let shapes = Shapes(elements)
        print(shapes.shapesAndNeighbors)
    }
}
