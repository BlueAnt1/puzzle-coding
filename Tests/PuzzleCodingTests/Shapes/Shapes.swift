//
//  Shapes.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/24/24.
//

@testable import PuzzleCoding

struct Shapes: RandomAccessCollection {
    /// The cells that constitute the shape.
    typealias Shape = Set<Int>
    private let shapes: Colorizer

    init(_ elements: [Int]) {
        assert(Size(gridCellCount: elements.count) != nil)
        let graph = Graph(elements)
        self.shapes = Colorizer(graph)
    }

    var startIndex: Int { shapes.startIndex }
    var endIndex: Int { shapes.endIndex }

    subscript(_ position: Int) -> (shape: Shape, color: Int) {
        return shapes[position]
    }
}

private struct Graph: RandomAccessCollection {
    typealias Shape = Shapes.Shape
    typealias Node = (shape: Shape, neighbors: Set<Int>)
    private let nodes: [Node]

    init(_ elements: [Int]) {
        let size = Size(gridCellCount: elements.count)!
        var visitedElements = Set<Int>()

        func node(containing index: Int) -> Node {
            visitedElements.insert(index)
            let left = index % size.rawValue > 0 ? index - 1 : nil
            let right = index % size.rawValue < size.rawValue - 1 ? index + 1 : nil
            let down = index + size.rawValue < elements.endIndex ? index + size.rawValue : nil
            let mates = [left, right, down].compactMap(\.self)
            let shapeMates = mates.filter { elements[$0] == elements[index] }

            var shape = Set([index] + shapeMates)
            var neighbors = Set(mates.filter { !shapeMates.contains($0) })

            for mate in shapeMates where !visitedElements.contains(mate) {
                let node = node(containing: mate)
                shape.formUnion(node.shape)
                neighbors.formUnion(node.neighbors)
            }

            return (shape, neighbors)
        }

        var nodes: [Node] = []
        for index in elements.indices where !visitedElements.contains(index) {
            nodes.append(node(containing: index))
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
    typealias Shape = Shapes.Shape
    typealias ColoredShape = (shape: Shape, color: Int)
    private let elements: [ColoredShape]

    init(_ graph: Graph) {
        let colorRange = Set(0...3)
        var colors: [Int] = []

        @discardableResult
        func colorize(_ node: Int) -> Bool {
            guard node < graph.endIndex else { return true }
            let neighborColors = graph[node].neighbors.filter(colors.indices.contains).map { colors[$0] }
            let colorOptions = colorRange.subtracting(neighborColors)
            for option in colorOptions.sorted() {
                colors.append(option)
                if colorize(colors.count) { return true }
                colors.removeLast()
            }
            return false
        }

        colorize(0)
        elements = zip(graph, colors).map { ($0.shape, $1) }
    }

    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }

    subscript(_ position: Int) -> ColoredShape {
        elements[position]
    }
}
