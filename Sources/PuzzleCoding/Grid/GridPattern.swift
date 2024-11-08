//
//  GridPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

import RegexBuilder

struct GridPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, grid: Grid)

    let size: Size

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let cellTransform = CellContentTransform(size: size)
        let fieldCoding = FieldCoding(range: cellTransform.range)

        let body = Regex {
            Capture {
                ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
            } transform: {
                ($0.0, grid: Grid(try $0.elements.map(cellTransform.decode)))
            }
        }

        guard let match = try? body.prefixMatch(in: input[index ..< bounds.upperBound]),
              let grid = match.output.1.grid
        else { return nil }

        return (match.range.upperBound, (match.output.0, grid))
    }
}

