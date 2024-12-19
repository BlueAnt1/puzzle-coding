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
    public init(region: Int? = nil, cage: CageInfo? = nil, content: Content? = nil) {
        self.region = region
        self.cage = cage
        self.content = content
    }
}
