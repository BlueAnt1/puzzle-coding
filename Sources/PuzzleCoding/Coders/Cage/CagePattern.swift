//
//  CagePattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/31/24.
//

import RegexBuilder

struct CagePattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, clues: [Int], shapes: [Int])

    let size: Size

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let cageCoding = CageCoding(size: size)
        let cages = Regex {
            Capture {
                FieldCoding(range: cageCoding.range, radix: PuzzleCoding.radix).arrayPattern(count: size.gridCellCount)
            } transform: {
                let decoded = cageCoding.decode($0.1)
                return ($0.0, clues: decoded.clues, shapes: decoded.shapes)
            }
        }

        guard let match = try? cages.regex.prefixMatch(in: input[index ..< bounds.upperBound]) else { return nil }
        return (match.range.upperBound, match.output.1)
    }
}
