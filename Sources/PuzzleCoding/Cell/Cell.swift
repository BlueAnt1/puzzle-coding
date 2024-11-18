//
//  Cell.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/12/24.
//

/// A puzzle cell.
///
/// Cell includes everything there is to know about a puzzle cell including its content and group & cage membership.
public struct Cell: Equatable, Sendable {
    /// The group of which the cell is a member.
    public var group: Int?
    /// The cage in which the cell is located and its clue information.
    public var cage: CageInfo?
    /// The clue, solution or candidates (progress).
    public var content: Content? {
        didSet {
            if case .candidates(let candidates) = content, candidates.isEmpty
            {
                content = nil
            }
        }
    }

    /// Creates an instance.
    public init(group: Int? = nil, cage: CageInfo? = nil, content: Content? = nil) {
        self.group = group
        self.cage = cage
        self.content = content
    }
}
