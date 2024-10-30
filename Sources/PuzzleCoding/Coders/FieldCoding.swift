//
//  FieldCoding.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

import RegexBuilder

struct FieldCoding {
    private let range: ClosedRange<Int>
    private let radix: Int
    private let fieldWidth: Int
    private let valuePattern: any RegexComponent<(Substring, Int)>
    private let padding: String

    init(range: ClosedRange<Int>, radix: Int) {
        assert(range.lowerBound >= 0 && (2...36).contains(radix))
        self.range = range
        self.radix = radix

        let fieldWidth = String(range.upperBound, radix: radix).count
        self.fieldWidth = fieldWidth

        let characters = {
            var characters = Set<Character>()
            for value in range where characters.count < radix {
                characters.formUnion(String(value, radix: radix))
            }
            return CharacterClass.anyOf(characters)
        }()

        valuePattern = Regex { Capture { Repeat(characters, count: fieldWidth) } transform: { Int($0, radix: radix)! }}.ignoresCase()
        padding = String(repeating: "0", count: fieldWidth - 1)
    }

    func arrayPattern(count: Int) -> some RegexComponent<(Substring, [Int])> {
        return ArrayPattern(count: count, valuePattern: valuePattern)

        struct ArrayPattern: CustomConsumingRegexComponent {
            typealias RegexOutput = (Substring, [Int])
            let count: Int
            let valuePattern: any RegexComponent<(Substring, Int)>

            func consuming(_ input: String,
                           startingAt index: String.Index,
                           in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
            {
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
    }

    func encode(_ value: Int, uppercase: Bool = false) -> String {
        assert(range.contains(value))
        return String((padding + String(value, radix: radix, uppercase: uppercase)).suffix(fieldWidth))
    }

    func encode(_ values: [Int], uppercase: Bool = false) -> String {
        values.map { encode($0, uppercase: uppercase) }.joined()
    }
}

private extension ClosedRange<Int> {
    var characters: CharacterClass {
        var characters = Set<Character>()
        for value in self where characters.count < PuzzleCoding.radix {
            characters.formUnion(String(value, radix: PuzzleCoding.radix))
        }
        return CharacterClass.anyOf(characters)
    }
}

