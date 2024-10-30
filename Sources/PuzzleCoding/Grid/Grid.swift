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
    public let size: Size
    private var content: [CellContent?]

    /// Creates an empty grid.
    /// - Parameter size: the size of the grid.
    public init(size: Size = .grid9x9) {
        self.size = size
        self.content = Array(repeating: nil, count: size.gridCellCount)
    }
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

