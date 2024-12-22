//
//  Puzzle.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/3/24.
//

/// A puzzle can be converted to and from a string.
public protocol Puzzle: RawRepresentable, RandomAccessCollection<Cell> {
    associatedtype Version

    /// The type of puzzle.
    var type: PuzzleType { get }
    
    /// The coding version.
    var version: Version { get set }

    /// The most modern version.
    static var currentVersion: Version { get }

    /// Creates an instance.
    /// - Parameters:
    ///     - cells: the puzzle content.
    ///     - version: the coding version.
    init(cells: some Collection<Cell>, version: Version) throws
    
    /// The encoded puzzle.
    var rawValue: String { get }
    
    /// Creates an instance if the rawValue is a recognized encoding of this puzzle type.
    /// - Parameter rawValue: an encoded puzzle.
    init?(rawValue: String)
}

extension Puzzle {
    /// Creates an instance using the current coding version.
    /// - Parameters:
    ///     - cells: the puzzle content.
    public init(cells: some Collection<Cell>) throws {
        try self.init(cells: cells, version: Self.currentVersion)
    }
}
