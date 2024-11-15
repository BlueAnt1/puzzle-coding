//
//  Grid.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//


import Testing
@testable import PuzzleCoding
import Foundation

struct Grid: CustomStringConvertible {
    private let cells: any Collection<Cell>

    init(_ cells: some Collection<Cell>) {
        self.cells = cells
    }

    var cellContent: String {
        func describe(_ cells: some Collection<Cell>) -> [String] {
            Array(zip(cells.indices, cells)
                .map { index, cell in
                    switch cell.content {
                    case .clue(let clue): "=\(clue)"
                    case .solution(let solution): "\(solution)"
                    case .candidates(let candidates): "[\(candidates.sorted().map(String.init).joined())]"
                    case nil: "."
                    }
                })
        }

        return format(describe(cells))
    }

    var cage: String {
        func describe(_ cells: some Collection<Cell>) -> [String] {
            return Array(zip(cells.indices, cells)
                .map { index, cell in
                    if let cage = cell.cage {
                        switch cage.content {
                        case nil: "\(cage.shape).__"
                        case .clue(let clue): "\(cage.shape).\(clue.formatted(.number.precision(.integerLength(2))))"
                        case .operator(let op): "\(cage.shape)._\(op)"
                        }
                    } else {
                        ""
                    }
                })
        }

        return format(describe(cells))
    }

    private func format(_ descriptions: [String]) -> String {
        guard let size = Size(gridCellCount: descriptions.count) else { return "" }
        let maxLength = descriptions.map(\.count).max() ?? 0
        let padding = String(repeating: " ", count: maxLength)

        return zip(0..., descriptions).reduce(into: "") { output, indexContent in
            let (index, content) = indexContent
            let isNewline = index.isMultiple(of: size.rawValue) && index != 0
            let isSpace = !(isNewline || index == 0)
            output.append(isNewline ? "\n" : isSpace ? " " : "")
            output.append(contentsOf: "\(padding)\(content)".suffix(maxLength))
        }
    }

    var description: String { cellContent }
}
