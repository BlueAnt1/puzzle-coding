//
//  CodingVersion.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/3/24.
//

/// The coding versions available for a puzzle.
public protocol CodingVersion: CaseIterable, Sendable {
    /// The current version.
    static var current: Self { get }
}
