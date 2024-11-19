//
//  Puzzle.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/3/24.
//

/// A puzzle can be converted to and from a string.
public protocol Puzzle: RawRepresentable, RandomAccessCollection<Cell> {
    associatedtype Version

    /// The coding version.
    var version: Version { get set }
    
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
