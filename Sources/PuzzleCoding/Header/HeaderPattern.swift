//
//  HeaderPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder
import Foundation

struct HeaderPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, puzzleType: PuzzleType, size: Size, version: Character)

    let sizes: any Collection<Size>

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let puzzleTypes = CharacterClass.anyOf(PuzzleType.allCases.map(\.rawValue))
        let sizes = CharacterClass.anyOf(sizes.flatMap { String($0.rawValue, radix: FieldCoding.radix) })
        let versions = CharacterClass.generalCategory(.uppercaseLetter)
        let regex = Regex {
            Capture { puzzleTypes } transform: { PuzzleType(rawValue: $0.uppercased().first!)! }
            Capture { sizes } transform: { Size(rawValue: Int($0, radix: FieldCoding.radix)!)! }
            Capture { versions } transform: { $0.uppercased().first! }
        }.ignoresCase()

        guard let header = try? regex.prefixMatch(in: input[index ..< bounds.upperBound]) else { return nil }
        return (header.range.upperBound, header.output)
    }
}
