//
//  Shapes.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/24/24.
//

import Testing
@testable import PuzzleCoding

struct Shapes {
    typealias Shape = Set<Int>

    private let shapes: ColoredGraph

    init?(_ elements: [Int]) {
        assert(Size(gridCellCount: elements.count) != nil)
        let graph = Self.graph(of: elements)
        guard let shapes = Self.colorize(graph) else { return nil }
        self.shapes = shapes
    }

    private typealias Graph = [(node: Shape, arcs: Set<Int>)]
    private typealias ColoredGraph = [(shape: Shape, color: Int)]

    private static func graph(of elements: [Int]) -> Graph {
        let size = Size(gridCellCount: elements.count)!
        var remaining = Set(elements.indices)

        func shapeAndNeighbors(of index: Int) -> (Shape, Set<Int>) {
            let up = index - size.rawValue >= 0 ? index - size.rawValue : nil
            let down = index + size.rawValue < elements.endIndex ? index + size.rawValue : nil
            let left = index % size.rawValue > 0 ? index - 1 : nil
            let right = index % size.rawValue < size.rawValue - 1 ? index + 1 : nil
            let mates = [up, down, left, right].compactMap(\.self)
            let shapeMates = mates.filter { elements[$0] == elements[index] }

            var shape = Set([index] + shapeMates)
            var neighbors = Set(mates.filter { !shapeMates.contains($0) })
            remaining.subtract([index])

            for mate in shapeMates where remaining.contains(mate) {
                let (s, n) = shapeAndNeighbors(of: mate)
                shape.formUnion(s)
                neighbors.formUnion(n)
                remaining.subtract(s)
            }

            return (shape, neighbors)
        }

        var graph: Graph = []
        for index in elements.indices where remaining.contains(index) {
            graph.append(shapeAndNeighbors(of: index))
        }

        // (shape: set of cell indices, neighbors: set of neighboring cell indices, make them set of neighboring shape indices)
        for index in graph.indices {
            graph[index].arcs = Set(graph[index].arcs.map { neighborCell in
                graph.firstIndex { $0.node.contains(neighborCell) }!
            })
        }

        return graph
    }

    private static func colorize(_ graph: Graph) -> ColoredGraph? {
        let colorRange = Set(0...3)
        var colors: [Int] = []

        func colorize(_ node: Int) -> Bool {
            guard node < graph.endIndex else { return true }
            let neighborColors = graph[node].arcs.compactMap { neighbor in
                colors.indices.contains(neighbor) ? colors[neighbor] : nil
            }
            let colorOptions = colorRange.subtracting(neighborColors).sorted()
            for option in colorOptions {
                colors.append(option)
                if colorize(colors.count) { return true }
                colors.removeLast()
            }
            return false
        }

        guard colorize(0) else { return nil }
        return zip(graph, colors).map { ($0.node, $1) }
    }
}

extension Shapes: RandomAccessCollection {
    var startIndex: Int { shapes.startIndex }
    var endIndex: Int { shapes.endIndex }

    subscript(_ position: Int) -> (shape: Shape, color: Int) {
        return shapes[position]
    }
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
