//
//  Size.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The size of a grid.
public struct Size: Equatable, Hashable, Comparable, CaseIterable, Sendable, CustomStringConvertible {
    /// The number of cells in a house.
    public let houseCellCount: Int

    /// Creates an instance if the dimension is supported.
    ///
    /// - Parameter houseCellCount: the number of cells in a row, column or box of a grid.
    public init?(houseCellCount: Int) {
        guard let index = Self.allCases.firstIndex(where: { houseCellCount == $0.houseCellCount }) else { return nil }
        self = Self.allCases[index]
    }

    private init(_ houseCellCount: Int) {
        self.houseCellCount = houseCellCount
    }

    /// The range of clues, values & candidates that can be stored in the grid.
    public var valueRange: ClosedRange<Int> { 1...houseCellCount }
    /// The number of cells in the grid.
    public var gridCellCount: Int { houseCellCount * houseCellCount }
    public var description: String { "\(houseCellCount)×\(houseCellCount)" }
    /// All supported grid sizes.
    public static let allCases = [Size(6), Size(8), Size(9), Size(16), Size(25)]
    public static var grid9x9: Size { allCases[2] }

    /// A size is less than another if it has fewer cells.
    public static func < (left: Size, right: Size) -> Bool {
        left.houseCellCount < right.houseCellCount
    }
}
