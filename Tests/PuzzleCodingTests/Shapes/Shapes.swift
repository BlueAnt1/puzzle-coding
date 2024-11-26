//
//  Shapes.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/24/24.
//

import Testing
@testable import PuzzleCoding

/// The cells that constitute the shape.
typealias Shape = Set<Int>

struct Shapes: RandomAccessCollection {
    private let shapes: Colorizer

    init?(_ elements: [Int]) {
        assert(Size(gridCellCount: elements.count) != nil)
        let graph = Graph(elements)
        guard let shapes = Colorizer(graph) else { return nil }
        self.shapes = shapes
    }

    var startIndex: Int { shapes.startIndex }
    var endIndex: Int { shapes.endIndex }

    subscript(_ position: Int) -> (shape: Shape, color: Int) {
        return shapes[position]
    }
}

private struct Graph: RandomAccessCollection {
    typealias Node = (shape: Shape, neighbors: Set<Int>)
    private let nodes: [Node]

    init(_ elements: [Int]) {
        let size = Size(gridCellCount: elements.count)!
        var visited = Set<Int>()

        func node(_ index: Int) -> Node {
            visited.insert(index)
            let up = index - size.rawValue >= 0 ? index - size.rawValue : nil
            let down = index + size.rawValue < elements.endIndex ? index + size.rawValue : nil
            let left = index % size.rawValue > 0 ? index - 1 : nil
            let right = index % size.rawValue < size.rawValue - 1 ? index + 1 : nil
            let mates = [up, down, left, right].compactMap(\.self)
            let shapeMates = mates.filter { elements[$0] == elements[index] }

            var shape = Set([index] + shapeMates)
            var neighbors = Set(mates.filter { !shapeMates.contains($0) })

            for mate in shapeMates where !visited.contains(mate) {
                let (s, n) = node(mate)
                shape.formUnion(s)
                neighbors.formUnion(n)
            }

            return (shape, neighbors)
        }

        var nodes: [Node] = []
        for index in elements.indices where !visited.contains(index) {
            nodes.append(node(index))
        }

        // (shape: set of cell indices, neighbors: set of cell indices) ->
        // (shape: set of cell indices, neighbors: set of _shape_ indices)
        for index in nodes.indices {
            nodes[index].neighbors = Set(nodes[index].neighbors.map { cell in
                nodes.firstIndex { $0.shape.contains(cell) }!
            })
        }

        self.nodes = nodes
    }

    var startIndex: Int { nodes.startIndex }
    var endIndex: Int { nodes.endIndex }

    subscript(_ position: Int) -> Node {
        nodes[position]
    }
}

private struct Colorizer: RandomAccessCollection {
    typealias ShapeColor = (shape: Shape, color: Int)
    private let elements: [ShapeColor]

    init?(_ graph: Graph) {
        let colorRange = Set(0...3)
        var colors: [Int] = []

        func colorize(_ node: Int) -> Bool {
            guard node < graph.endIndex else { return true }
            let neighborColors = graph[node].neighbors.compactMap { neighbor in
                colors.indices.contains(neighbor) ? colors[neighbor] : nil
            }
            let colorOptions = colorRange.subtracting(neighborColors)
            for option in colorOptions.sorted() {
                colors.append(option)
                if colorize(colors.count) { return true }
                colors.removeLast()
            }
            return false
        }

        guard colorize(0) else { return nil }
        elements = zip(graph, colors).map { ($0.shape, $1) }
    }

    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }

    subscript(_ position: Int) -> ShapeColor {
        elements[position]
    }
}

struct TestShapes {
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
