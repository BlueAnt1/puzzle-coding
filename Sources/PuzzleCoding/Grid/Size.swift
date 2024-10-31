//
//  Size.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The size of a grid.
public enum Size: RawRepresentable, Equatable, Hashable, CaseIterable, Sendable, CustomStringConvertible {
    /// A grid with 6 cells per house & 2×3 boxes.
    case grid6x6
    /// A grid with 8 cells per house & 2×4 boxes.
    case grid8x8
    /// A grid with 9 cells per house &  3×3 boxes.
    case grid9x9
    /// A grid with 16 cells per house & 4×4 boxes.
    case grid16x16
    /// A grid with 25 cells per house & 5×5 boxes.
    case grid25x25

    /// The number of rows in a box.
    public var boxRowCount: Int { dimensions.boxRowCount }
    /// The number of columns in a box.
    public var boxColumnCount: Int { dimensions.boxColumnCount }
    /// The number of cells in a house.
    public var houseCellCount: Int { boxRowCount * boxColumnCount }
    /// The number of cells in the grid.
    public var gridCellCount: Int { houseCellCount * houseCellCount }
    /// The range of clues, values & candidates that can be stored in the grid.
    public var valueRange: ClosedRange<Int> { 1...houseCellCount }

    private var dimensions: (boxRowCount: Int, boxColumnCount: Int) {
        switch self {
        case .grid6x6: return (2, 3)
        case .grid8x8: return (2, 4)
        case .grid9x9: return (3, 3)
        case .grid16x16: return (4, 4)
        case .grid25x25: return (5, 5)
        }
    }

    /// The number of cells in a house (houseCellCount)
    public var rawValue: Int { houseCellCount }

    /// Creates an instance if the rawValue matches a supported `houseCellCount`.
    /// Supported values are: 6, 8, 9, 16 and 25.
    public init?(rawValue: Int) {
        guard let size = Self.allCases.first(where: { $0.rawValue == rawValue }) else { return nil }
        self = size
    }

    public var description: String { "\(houseCellCount)×\(houseCellCount)" }
}
