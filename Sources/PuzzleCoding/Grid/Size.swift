//
//  Size.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The size of a grid.
public enum Size: Int, Equatable, Hashable, CaseIterable, Sendable, CustomStringConvertible {
    // raw values are used to encode the size in the encoding header
    case shape2x3 = 5, shape2x4 = 6, shape3x2 = 7, shape4x2 = 8
    case shape3x3 = 9, shape4x4 = 16, shape5x5 = 25

    /// The number of rows in a box.
    public var boxRowCount: Int { Self.dimensions[self]!.boxRowCount }
    /// The number of columns in a box.
    public var boxColumnCount: Int { Self.dimensions[self]!.boxColumnCount }
    /// The number of cells in a house.
    public var houseCellCount: Int { boxRowCount * boxColumnCount }
    /// The number of cells in the grid.
    public var gridCellCount: Int { houseCellCount * houseCellCount }
    /// The range of clues, values & candidates that can be stored in the grid.
    public var valueRange: ClosedRange<Int> { 1...houseCellCount }
    
    private static let dimensions: [Size : (boxRowCount: Int, boxColumnCount: Int)] = [
        .shape2x3: (2, 3),
        .shape2x4: (2, 4),
        .shape3x2: (3, 2),
        .shape4x2: (4, 2),
        .shape3x3: (3, 3),
        .shape4x4: (4, 4),
        .shape5x5: (5, 5)
    ]

    /// A 9×9 grid.
    public static var grid9x9: Size { .shape3x3 }
    
    public var description: String { "\(houseCellCount)×\(houseCellCount)" }
}
