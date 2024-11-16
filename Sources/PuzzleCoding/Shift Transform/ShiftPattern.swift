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
    let transform: ShiftTransform

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let fieldCoding = FieldCoding(range: transform.range)
        let values = Regex {
            Capture {
                ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)
            } transform: {
                let decoded = try $0.elements.map(transform.decode)
                return ($0.0, decoded)
            }
        }

        guard let match = try? values.prefixMatch(in: input[index ..< bounds.upperBound])
        else { return nil }
        return (match.range.upperBound, match.output.1)
    }
}
