//
//  ShiftedKillerPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

import RegexBuilder

struct ShiftPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, values: [[Int]])

    let size: Size
    let ranges: [ClosedRange<Int>]

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let shiftTransform = ShiftTransform(ranges: ranges)
        let fieldCoding = FieldCoding(range: shiftTransform.range)
        let values = Regex {
            Capture {
                ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
            } transform: {
                let decoded = $0.elements.compactMap(shiftTransform.decode)
                guard decoded.count == size.gridCellCount else { return nil as Self.RegexOutput? }
                return ($0.0, decoded)
            }
        }

        guard let match = try? values.prefixMatch(in: input[index ..< bounds.upperBound]),
              let output = match.output.1 else { return nil }
        return (match.range.upperBound, output)
    }
}
