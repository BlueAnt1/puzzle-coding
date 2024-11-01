//
//  KillerPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

import RegexBuilder

struct KillerPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, clues: [Int], shapes: [[Int]])?

    let size: Size
    let shapeRanges: [ClosedRange<Int>]

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let killerCoding = KillerCoding(size: size, shapeRanges: shapeRanges)
        let killer = Regex {
            Capture {
                FieldCoding(range: killerCoding.range, radix: PuzzleCoding.radix).arrayPattern(count: size.gridCellCount)
            } transform: {
                guard let decoded = killerCoding.decode(from: $0.values) else { return nil as Self.RegexOutput }
                return ($0.0, decoded.clues, decoded.shapes)
            }
        }

        guard let match = try? killer.regex.prefixMatch(in: input[index ..< bounds.upperBound]),
              let output = match.output.1 else { return nil }
        return (match.range.upperBound, (output.0, output.clues, output.shapes))
    }
}
