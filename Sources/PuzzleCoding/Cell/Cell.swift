//
//  Cell.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/12/24.
//

public struct Cell: Equatable, Sendable {
    public var box: (shape: Int, color: Int)? = nil
    public var cage: (shape: Int, content: CageContent?)? = nil
    public var content: CellContent? = nil {
        didSet {
            if case .candidates(let candidates) = content, candidates.isEmpty {
                content = nil
            }
        }
    }

    public init(box: (shape: Int, color: Int)? = nil,
                cage: (shape: Int, content: CageContent?)? = nil,
                content: CellContent? = nil)
    {
        self.box = box
        self.cage = cage
        self.content = content
    }

    public static func == (left: Cell, right: Cell) -> Bool {
        left.content == right.content
        && left.cage?.shape == right.cage?.shape
        && left.cage?.content == right.cage?.content
        && left.box?.shape == right.box?.shape
        && left.box?.color == right.box?.color
    }
}
