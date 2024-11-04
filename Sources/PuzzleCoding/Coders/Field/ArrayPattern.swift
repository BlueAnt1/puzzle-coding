//
//  ArrayPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import RegexBuilder

struct ArrayPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, values: [Int])

    let count: Int
    let range: ClosedRange<Int>
    let radix: Int

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let valuePattern = FieldCoding(range: range, radix: radix).valuePattern
        var array = [Int]()
        var elementIndex = index
        while bounds.contains(elementIndex) && array.count < count {
            guard let match = try? valuePattern.regex.prefixMatch(in: input[elementIndex..<bounds.upperBound]) else { return nil }
            array.append(match.output.1)
            elementIndex = match.range.upperBound
        }
        guard array.count == count else { return nil }
        return (elementIndex, (input[index ..< elementIndex], array))
    }
}
