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

    var group: String {
        func describe(_ cells: some Collection<Cell>) -> [String] {
            cells.map { if let region = $0.region { "\(region)" } else { " " }}
        }
        return format(describe(cells))
    }

    var cage: String {
        func describe(_ cells: some Collection<Cell>) -> [String] {
            return Array(zip(cells.indices, cells)
                .map { index, cell in
                    if case .cage(id: let cageID, operator: let op) = cell.clue {
                        switch op {
                        case nil: "\(cageID).__"
                        case .add(let operand), .subtract(let operand),
                                .multiply(let operand), .divide(let operand):
                            "\(cageID).\(operand)"
                        }
                    } else {
                        ""
                    }
                })
        }

        return format(describe(cells))
    }

    var cellContent: String {
        func describe(_ cells: some Collection<Cell>) -> [String] {
            Array(zip(cells.indices, cells)
                .map { index, cell in
                    if case .solution(let clue) = cell.clue {
                        "=\(clue)"
                    } else if case .blackEmpty = cell.clue {
                        "⩦"
                    } else if case .black(let clue) = cell.clue {
                        "≠\(clue)"
                    } else if case .guess(let guess) = cell.progress {
                        "\(guess)"
                    } else if case .candidates(let candidates) = cell.progress {
                        "[\(candidates.sorted().map(String.init).joined())]"
                    } else {
                        "."
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
