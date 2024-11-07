//
//  PuzzleCodingTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/25/24.
//

import Testing
import RegexBuilder
@testable import PuzzleCoding

struct FieldCodingTests {
    @Test
    func valueCodes() throws {
        let coding = FieldCoding(range: 0...100, radix: 36)
        #expect(coding.encode(0) == "00")
        #expect(coding.encode(100) == "2s")

        #expect(coding.encode(10) == "0a")
    }

    @Test
    func binaryCodes() throws {
        let fieldCoding = FieldCoding(range: 0...7, radix: 2)
        #expect(fieldCoding.encode(7) == "111")
        #expect(fieldCoding.encode(0) == "000")
        #expect(fieldCoding.encode(1) == "001")

        #expect(fieldCoding.decode("111") == 7)
        #expect(fieldCoding.decode("000") == 0)
        #expect(fieldCoding.decode("001") == 1)

        let pattern = ArrayPattern(repeating: fieldCoding.pattern, count: 1)

        do {
            let match = try #require(try? pattern.regex.wholeMatch(in: "111"))
            #expect(match.output.elements == [7])
        }
        do {
            let match = try #require(try? pattern.regex.wholeMatch(in: "000"))
            #expect(match.output.elements == [0])
        }
        do {
            let match = try #require(try? pattern.regex.wholeMatch(in: "001"))
            #expect(match.output.elements == [1])
        }
    }

    @Test
    func valueDecodes() throws {
        let fieldCoding = FieldCoding(range: 0...100, radix: 36)
        let regex = ArrayPattern(repeating: fieldCoding.pattern, count: 1).regex

        let upperMatch = try #require(try? regex.wholeMatch(in: "0Z"))
        #expect(upperMatch.output.1 == [35])
        let lowerMatch = try #require(try? regex.wholeMatch(in: "0z"))
        #expect(lowerMatch.output.1 == [35])
    }

    @Test
    func arrayCodes() throws {
        let fieldCoding = FieldCoding(range: 0...100, radix: 36)
        let input = [0, 6, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        let encoded = input.map(fieldCoding.encode).joined()

        let pattern = ArrayPattern(repeating: fieldCoding.pattern, count: input.count)
        let decoded = try #require(try? pattern.regex.wholeMatch(in: encoded))
        #expect(decoded.output.1 == input)
    }
}
