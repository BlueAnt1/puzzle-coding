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
            guard radix > 10 else {
                var characters = Set<Character>()
                for value in range where characters.count < radix {
                    characters.formUnion(String(value, radix: radix))
                }
                return CharacterClass.anyOf(characters)
            }
            var upper = Set<Character>()
            for value in range where upper.count < radix {
                upper.formUnion(String(value, radix: radix, uppercase: true))
            }
            var lower = Set<Character>()
            for value in range where lower.count < radix {
                lower.formUnion(String(value, radix: radix, uppercase: false))
            }
            return CharacterClass.anyOf(upper.union(lower))
        }()

        valuePattern = Regex { Capture { Repeat(characters, count: fieldWidth) } transform: { Int($0, radix: radix)! }}
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
