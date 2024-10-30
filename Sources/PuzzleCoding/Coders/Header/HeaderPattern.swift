//
//  HeaderPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder
import Foundation

struct HeaderPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, Size)

    let puzzleType: PuzzleType
    let version: Character

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let size = Reference<Size>()
        let regex = Regex {
            puzzleType.rawValue
            Capture(as: size) { Size.characters } transform: { Size(houseCellCount: Int($0)!)! }
            version
        }.ignoresCase()

        guard let header = try? regex.prefixMatch(in: input[index ..< bounds.upperBound]) else { return nil }

        return (header.range.upperBound, (header.output.0, header.output.1))
    }
}

private extension Size {
    static var characters: CharacterClass {
        CharacterClass.anyOf(allCases.map(\.houseCellCount).map { String($0, radix: PuzzleCoding.radix).first! })
    }
}
