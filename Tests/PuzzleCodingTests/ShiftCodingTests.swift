//
//  ShiftCodingTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
@testable import PuzzleCoding

struct ShiftCodingTests {

    @Test
    func emptyRangesCode() throws {
        let coding = ShiftCoding(ranges: [])
        #expect(coding.isEncodable([]))
        #expect(!coding.isEncodable([[]]))
        #expect(!coding.isEncodable([[1]]))
    }

    @Test
    func oneRangeCodes() throws {
        let coding = ShiftCoding(ranges: [0...5])
        #expect(coding.isEncodable([[0]]))
        #expect(coding.isEncodable([[2]]))
        #expect(coding.isEncodable([[5]]))
        #expect(!coding.isEncodable([[6]]))
        #expect(!coding.isEncodable([[0], [0]]))
        #expect(!coding.isEncodable([[5], [5]]))
    }

    @Test
    func zeroLowerBound() throws {
        let coding = ShiftCoding(ranges: [0...5])
        #expect(coding.encode([0]) == 0)
        #expect(coding.encode([5]) == 5)
    }

    @Test
    func nonzeroLowerBoundShifts() throws {
        let coding = ShiftCoding(ranges: [2...5])
        #expect(coding.encode([2]) == 0)
        #expect(coding.encode([5]) == 3)
    }

    @Test
    func twoValuesShift() throws {
        let coding = ShiftCoding(ranges: [0...9, 1...5])
        #expect(coding.encode([0, 1]) == 0)
        #expect(coding.encode([0, 2]) == 1)
        #expect(coding.encode([1, 1]) == 8)
        #expect(coding.encode([9, 5]) == 76)
    }

    @Test
    func threeValuesShift() throws {
        let coding = ShiftCoding(ranges: [0...9, 1...5, 1...5])
        #expect(coding.encode([0, 1, 1]) == 0)
        #expect(coding.encode([0, 1, 2]) == 1)
        #expect(coding.encode([0, 1, 5]) == 4)
        #expect(coding.encode([0, 2, 1]) == 8)
        #expect(coding.encode([0, 2, 5]) == 12)
        #expect(coding.encode([0, 5, 5]) == 36)
        #expect(coding.encode([1, 1, 1]) == 64)
        #expect(coding.encode([9, 5, 5]) == 612)
    }

    @Test
    func roundTrip() throws {
        let coding = ShiftCoding(ranges: [0...9, 1...5, 1...5])
        let expected = [9, 5, 5]
        let encoded = coding.encode(expected)
        let decoded = try #require(coding.decode(encoded))
        #expect(decoded == expected)
    }
}
