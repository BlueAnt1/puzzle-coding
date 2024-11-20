//
//  Size.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

/// The size of a grid.
struct Size: RawRepresentable, Equatable, Hashable, CaseIterable, Sendable, CustomStringConvertible {
    private static let allValues = Array(3...9) + [16, 25]
    static var allCases: [Size] { allValues.map(Size.init) }

    let rawValue: Int

    private init(_ rawValue: Int) {
        self.rawValue = rawValue
    }

    init?(rawValue: Int) {
        guard Self.allValues.contains(rawValue) else { return nil }
        self.rawValue = rawValue
    }

    /// The number of cells in the grid.
    public var gridCellCount: Int { rawValue * rawValue }
    /// The range of clues, solutions & candidates that can be stored in the grid.
    public var valueRange: ClosedRange<Int> { 1...rawValue }

    public var description: String { "\(rawValue)×\(rawValue)" }
}

extension Size {
    init?(gridCellCount: Int) {
        guard let size = Size.allCases.first(where: { $0.gridCellCount == gridCellCount }) else { return nil }
        self = size
    }

    static var grid9x9: Size { .init(9) }
}
