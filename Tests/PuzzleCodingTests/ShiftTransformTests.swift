//
//  ShiftTransformTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
@testable import PuzzleCoding

struct ShiftTransformTests {

    @Test
    func oneRangeCodes() throws {
        let transform = ShiftTransform(ranges: [0...5])
        #expect(transform.isEncodable([[0]]))
        #expect(transform.isEncodable([[2]]))
        #expect(transform.isEncodable([[5]]))
        #expect(!transform.isEncodable([[6]]))
        #expect(!transform.isEncodable([[0], [0]]))
        #expect(!transform.isEncodable([[5], [5]]))
    }

    @Test
    func zeroLowerBound() throws {
        let transform = ShiftTransform(ranges: [0...5])
        #expect(transform.encode([0]) == 0)
        #expect(transform.encode([5]) == 5)
    }

    @Test
    func nonzeroLowerBoundShifts() throws {
        let transform = ShiftTransform(ranges: [2...5])
        #expect(transform.encode([2]) == 0)
        #expect(transform.encode([5]) == 3)
    }

    @Test
    func twoValuesShift() throws {
        let transform = ShiftTransform(ranges: [0...9, 1...5])
        #expect(transform.encode([0, 1]) == 0)
        #expect(transform.encode([0, 2]) == 1)
        #expect(transform.encode([1, 1]) == 8)
        #expect(transform.encode([9, 5]) == 76)
    }

    @Test
    func threeValuesShift() throws {
        let transform = ShiftTransform(ranges: [0...9, 1...5, 1...5])
        #expect(transform.encode([0, 1, 1]) == 0)
        #expect(transform.encode([0, 1, 2]) == 1)
        #expect(transform.encode([0, 1, 5]) == 4)
        #expect(transform.encode([0, 2, 1]) == 8)
        #expect(transform.encode([0, 2, 5]) == 12)
        #expect(transform.encode([0, 5, 5]) == 36)
        #expect(transform.encode([1, 1, 1]) == 64)
        #expect(transform.encode([9, 5, 5]) == 612)
    }

    @Test
    func roundTrip() throws {
        let transform = ShiftTransform(ranges: [0...9, 1...5, 1...5])
        let expected = [9, 5, 5]
        let encoded = transform.encode(expected)
        let decoded = try #require(transform.decode(encoded))
        #expect(decoded == expected)
    }
}
