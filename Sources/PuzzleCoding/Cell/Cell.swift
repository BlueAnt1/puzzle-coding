//
//  Cell.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/12/24.
//

/// A puzzle cell.
///
/// Cell describes everything there is to know about a puzzle cell.
public struct Cell: Equatable, Sendable {
    /// A shape that provides clues about a region of a puzzle.
    public typealias Cage = (shape: Int, content: CageContent?)

    /// The identifier for the group in which the cell is located.
    public var group: Int?
    /// The cage in which the cell is located and clue information.
    public var cage: Cage?
    /// The clue or progress.
    public var content: CellContent? {
        didSet {
            if case .candidates(let candidates) = content, candidates.isEmpty
            {
                content = nil
            }
        }
    }

    /// Creates an instance.
    public init(group: Int? = nil,
                cage: Cage? = nil,
                content: CellContent? = nil)
    {
        self.group = group
        self.cage = cage
        self.content = content
    }

    public static func == (left: Cell, right: Cell) -> Bool {
        left.content == right.content
        && left.cage?.shape == right.cage?.shape
        && left.cage?.content == right.cage?.content
        && left.group == right.group
    }
}
