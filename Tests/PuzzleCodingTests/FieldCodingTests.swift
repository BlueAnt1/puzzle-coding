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

        #expect(coding.encode(10, uppercase: true) == "0A")
        #expect(coding.encode(10, uppercase: false) == "0a")
        #expect(coding.encode(10) == "0a")
    }

    @Test
    func binaryCodes() throws {
        let coding = FieldCoding(range: 0...7, radix: 2)
        #expect(coding.encode(7) == "111")
        #expect(coding.encode(0) == "000")
        #expect(coding.encode(1) == "001")

        do {
            let match = try #require(try? coding.arrayPattern(count: 1).regex.wholeMatch(in: "111"))
            #expect(match.output.1 == [7])
        }
        do {
            let match = try #require(try? coding.arrayPattern(count: 1).regex.wholeMatch(in: "000"))
            #expect(match.output.1 == [0])
        }
        do {
            let match = try #require(try? coding.arrayPattern(count: 1).regex.wholeMatch(in: "001"))
            #expect(match.output.1 == [1])
        }
    }

    @Test
    func valueDecodes() throws {
        let coding = FieldCoding(range: 0...100, radix: 36)
        let regex = coding.arrayPattern(count: 1).regex

        let upperMatch = try #require(try? regex.wholeMatch(in: "0Z"))
        #expect(upperMatch.output.1 == [35])
        let lowerMatch = try #require(try? regex.wholeMatch(in: "0z"))
        #expect(lowerMatch.output.1 == [35])
    }

    @Test
    func arrayCodes() throws {
        let coding = FieldCoding(range: 0...100, radix: 36)
        let input = [0, 6, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        let encoded = coding.encode(input)
        let decoded = try #require(try? coding.arrayPattern(count: input.count).regex.wholeMatch(in: encoded))
        #expect(decoded.output.1 == input)
    }
}
