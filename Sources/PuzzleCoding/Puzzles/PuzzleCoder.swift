//
//  PuzzleCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/3/24.
//

/// The coding versions available for a puzzle.
public protocol VersionProtocol: CaseIterable, Sendable {
    /// The current version.
    static var current: Self { get }
}

public protocol PuzzleCoder {
    /// The coding version.
    associatedtype Version: VersionProtocol

    /// Decode the input using the specified coding version.
    /// - Parameters:
    ///     - input: The raw input to decode.
    ///     - version: The coding version.
    /// - Returns: the decoded puzzle or `nil` if the input is not recognized.
    static func decode(_ input: String, using version: Version) -> Self?

    /// Creates a textual representation of the puzzle using the specified coding version.
    /// - Parameter version: the format in which to encode the puzzle.
    /// - Returns: the textual representation.
    func encode(using version: Version) -> String
}

extension PuzzleCoder {
    /// Decode the puzzle from the provided input by attempting all coding versions.
    /// - Parameter input: The raw input to decode.
    /// - Returns: The puzzle & coding version if the input is recognized, `nil` otherwise.
    public static func decode(_ input: String) -> (puzzle: Self, version: Version)? {
        for version in Version.allCases {
            if let puzzle = decode(input, using: version) {
                return (puzzle, version)
            }
        }
        return nil
    }
}

