//
//  Cell.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/12/24.
//

/// A puzzle cell.
///
/// Cell includes everything there is to know about a puzzle cell including its content and region & cage membership.
public struct Cell: Equatable, Sendable {
    /// The region of which the cell is a member.
    public var region: Int?
    /// The cage in which the cell is located and its clue information.
    public var clue: Clue?
    /// The clue, solution or candidates (progress).
    public var content: Content? {
        didSet {
            if let normalized = content?.normalized, content != normalized {
                content = normalized
            }
        }
    }

    /// Creates an instance.
    public init(region: Int? = nil, clue: Clue? = nil, content: Content? = nil) {
        self.region = region
        self.clue = clue
        self.content = content?.normalized
    }
}
