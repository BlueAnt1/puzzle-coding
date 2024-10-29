//
//  Grid.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// A Grid represents the clues & progress of a puzzle.
///
/// A Grid is a collection of ``CellContent``. Access the content of the grid using subscripts.
public struct Grid: Equatable {
    /// The size of the grid.
    private var content: [CellContent?]
    let boxShape: BoxShape

    /// Creates an instance if the size and cell content are compatible.
    /// - Parameters:
    ///     - boxShape: the shape of the boxes of the grid. The box shape determines the size of the grid.
    ///     - content: the items stored in the grid. An empty cell is represented as `nil`.
    public init?(boxShape: BoxShape, content: [CellContent?]) {
        let size = boxShape.size
        guard size.gridCellCount == content.count,
              content.allSatisfy({ $0.map { $0.isValid(in: size.valueRange) } ?? true })
        else { return nil }
        self.init(boxShape: boxShape)
        indices.forEach { self[$0] = content[$0] }  // clean up candidates
    }

    /// Creates an empty grid.
    /// - Parameter boxShape: the shape of the boxes of the grid. The box shape determines the size of the grid.
    public init(boxShape: BoxShape = .grid9x9) {
        self.boxShape = boxShape
        self.content = Array(repeating: nil, count: boxShape.size.gridCellCount)
    }

    var size: Size { boxShape.size }
}

extension Grid: RandomAccessCollection {
    public var startIndex: Int { content.startIndex }
    public var endIndex: Int { content.endIndex }
    public subscript(position: Int) -> CellContent? {
        get { content[position] }
        set {
            newValue.map { precondition($0.isValid(in: size.valueRange)) }
            content[position] = if case .candidates(let candidates) = newValue, candidates.isEmpty { nil } else { newValue }
        }
    }
}

