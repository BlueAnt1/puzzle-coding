//
//  ArrayPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import RegexBuilder

struct ArrayPattern<Element>: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, values: [Element])

    let elementPattern: any RegexComponent<(Substring, Element)>
    let count: Int

    init(repeating elementPattern: some RegexComponent<(Substring, Element)>, count: Int) {
        self.elementPattern = elementPattern
        self.count = count
    }
    
    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        var array = [Element]()
        var elementIndex = index
        while bounds.contains(elementIndex) && array.count < count {
            guard let match = try? elementPattern.regex.prefixMatch(in: input[elementIndex..<bounds.upperBound]) else { return nil }
            array.append(match.output.1)
            elementIndex = match.range.upperBound
        }
        guard array.count == count else { return nil }
        return (elementIndex, (input[index ..< elementIndex], array))
    }
}
