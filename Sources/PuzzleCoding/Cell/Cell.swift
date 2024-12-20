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
    /// The cell clue including cage and solution values.
    public var clue: Clue?
    /// The player's solution or candidates.
    public var progress: Progress? {
        didSet {
            if let normalized = progress?.normalized, progress != normalized {
                progress = normalized
            }
        }
    }

    /// Creates an instance.
    public init(region: Int? = nil, clue: Clue? = nil, progress: Progress? = nil) {
        self.region = region
        self.clue = clue
        self.progress = progress?.normalized
    }
}
