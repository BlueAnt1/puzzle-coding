//
//  HeaderPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

struct HeaderPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, BoxShape)

    let version: Character

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let rows = Reference<Int>()
        let columns = Reference<Int>()
        let regex = Regex {
            version
            Capture(as: rows) { .digit } transform: { Int($0)! }
            Capture(as: columns) { .digit } transform: { Int($0)! }
        }

        guard let header = try? regex.prefixMatch(in: input[index ..< bounds.upperBound]),
              let boxShape = BoxShape(rows: header[rows], columns: header[columns])
        else { return nil }

        return (header.range.upperBound, (header.output.0, boxShape))
    }
}
