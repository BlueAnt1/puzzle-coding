//
//  Grid.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//


import Testing
@testable import PuzzleCoding

struct Grid: CustomStringConvertible {
    let cells: any Collection<Cell>

    init(_ cells: some Collection<Cell>) {
        self.cells = cells
    }

    var description: String {
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
        guard let size = Size(gridCellCount: cells.count) else { return "" }
        let padding = String(repeating: " ", count: size.rawValue + 2)  // +2 for "[" and "]"
        let descriptions = describe(cells)
        return zip(0..., descriptions).reduce(into: "") { output, indexContent in
            let isNewline = indexContent.0.isMultiple(of: size.rawValue) && indexContent.0 != 0
            output.append(isNewline ? "\n" : " ")
            output.append(contentsOf: "\(padding)\(indexContent.1)".suffix(size.rawValue + 2))
        }
    }
}
