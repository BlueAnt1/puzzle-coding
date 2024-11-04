//
//  FieldCoding.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

import RegexBuilder

struct FieldCoding {
    let range: ClosedRange<Int>
    private let radix: Int
    private let fieldWidth: Int
    let pattern: any RegexComponent<(Substring, Int)>
    private let padding: String

    init(range: ClosedRange<Int>, radix: Int) {
        assert(range.lowerBound >= 0 && (2...36).contains(radix))
        self.range = range
        self.radix = radix

        let fieldWidth = String(range.upperBound, radix: radix).count
        self.fieldWidth = fieldWidth

        let characters = range.charactersToEncode(radix: radix)
        pattern = Regex {
            Capture {
                Repeat(characters, count: fieldWidth)
            } transform: { Int($0, radix: radix)! }
        }.ignoresCase()

        padding = String(repeating: "0", count: fieldWidth - 1)
    }

    func encode(_ value: Int) -> String {
        assert(range.contains(value))
        return String((padding + String(value, radix: radix)).suffix(fieldWidth))
    }

    func decode(_ value: String) -> Int? {
        guard let value = Int(value, radix: radix), range.contains(value) else { return nil }
        return value
    }
}

private extension ClosedRange<Int> {
    func charactersToEncode(radix: Int) -> CharacterClass {
        var characters = Set<Character>()
        for value in self where characters.count < radix {
            characters.formUnion(String(value, radix: radix))
        }
        return CharacterClass.anyOf(characters)
    }
}

