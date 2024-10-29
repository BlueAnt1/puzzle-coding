//
//  BoxShape.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/27/24.
//

/// The dimensions of a grid box.
public struct BoxShape: Equatable, CaseIterable, Sendable, CustomStringConvertible {
    /// The number of rows in the box.
    public let rows: Int
    /// The number of columns in the box.
    public let columns: Int

    /// Creates an instance if the dimensions are supported.
    /// - Parameters:
    ///     - rows: the number of rows in the box
    ///     - columns: the number of columns in the box
    public init?(rows: Int, columns: Int) {
        let shape = BoxShape(rows, columns)
        guard Self.allCases.contains(shape) else { return nil }
        self = shape
    }

    private init(_ rows: Int, _ columns: Int) {
        self.rows = rows
        self.columns = columns
    }

    /// All supported box shapes.
    public static let allCases = [BoxShape(2, 3), BoxShape(3, 2), BoxShape(2, 4), BoxShape(4, 2), BoxShape(3, 3)]

    /// The shape that defines a 9×9 grid.
    public static var grid9x9: BoxShape { Self.allCases.last! }
    public var description: String { "\(rows)×\(columns)" }
    /// The size of the grid defined by this shape.
    public var size: Size { Size(houseCellCount: rows * columns)! }
}
