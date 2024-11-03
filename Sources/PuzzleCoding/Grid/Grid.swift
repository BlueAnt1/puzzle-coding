//
//  Grid.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The clues & progress of a puzzle.
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

    /// Creates a grid containing the elements of the content.
    /// - Parameter content: The cell content.
    public init?<C>(_ content: C) where C: Collection, C.Element == Grid.Element {
        guard let size = Size.allCases.first(where: { content.count == $0.gridCellCount }),
              content.allSatisfy({ $0.map { $0.isValid(in: size.valueRange) } ?? true })
        else { return nil }

        self.init(size: size)
        for (index, contentIndex) in zip(indices, content.indices) {
            self[index] = content[contentIndex]
        }
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

