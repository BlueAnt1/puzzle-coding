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
        let coding = FieldCoding(range: 0...7, radix: 2)
        #expect(coding.encode(7) == "111")
        #expect(coding.encode(0) == "000")
        #expect(coding.encode(1) == "001")

        #expect(coding.decode("111") == 7)
        #expect(coding.decode("000") == 0)
        #expect(coding.decode("001") == 1)
//        let pattern = ArrayPattern(range: coding.range, count: 1)
//
//        do {
//            let match = try #require(try? pattern.regex.wholeMatch(in: "111"))
//            #expect(match.output.1 == [7])
//        }
//        do {
//            let match = try #require(try? pattern.regex.wholeMatch(in: "000"))
//            #expect(match.output.1 == [0])
//        }
//        do {
//            let match = try #require(try? pattern.regex.wholeMatch(in: "001"))
//            #expect(match.output.1 == [1])
//        }
    }

    @Test
    func valueDecodes() throws {
        let regex = ArrayPattern(count: 1, range: 0...100, radix: 36).regex

        let upperMatch = try #require(try? regex.wholeMatch(in: "0Z"))
        #expect(upperMatch.output.1 == [35])
        let lowerMatch = try #require(try? regex.wholeMatch(in: "0z"))
        #expect(lowerMatch.output.1 == [35])
    }

    @Test
    func arrayCodes() throws {
        let coding = FieldCoding(range: 0...100, radix: 36)
        let input = [0, 6, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        let encoded = input.map(coding.encode).joined()

        let pattern = ArrayPattern(count: input.count, range: coding.range, radix: 36)
        let decoded = try #require(try? pattern.regex.wholeMatch(in: encoded))
        #expect(decoded.output.1 == input)
    }
}
