//
//  Size.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The size of a grid.
public enum Size: Int, Equatable, Hashable, CaseIterable, Sendable, CustomStringConvertible {
    /// A grid with 6 cells per house.
    case grid6x6 = 6
    /// A grid with 8 cells per house .
    case grid8x8 = 8
    /// A grid with 9 cells per house.
    case grid9x9 = 9
    /// A grid with 16 cells per house.
    case grid16x16 = 16
    /// A grid with 25 cells per house.
    case grid25x25 = 25

    /// The number of cells in the grid.
    public var gridCellCount: Int { rawValue * rawValue }
    /// The range of clues, solutions & candidates that can be stored in the grid.
    public var valueRange: ClosedRange<Int> { 1...rawValue }

    public var description: String { "\(rawValue)×\(rawValue)" }
}
