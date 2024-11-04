//
//  ShiftCoding.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

/// Generic shift coding.
struct ShiftCoding {
    private let ranges: [ClosedRange<Int>]
    private let offsets: [Int]
    let range: ClosedRange<Int>

    init(ranges: [ClosedRange<Int>]) {
        assert(ranges.allSatisfy { $0.lowerBound >= 0 })
        self.ranges = ranges
        let maxValues = ranges.map { $0.upperBound - $0.lowerBound }
        let offsets = [0] + maxValues.dropFirst().map { String($0, radix: 2).count }
        self.offsets = offsets
        let maxValue = ranges.indices.reduce(0) { maxValue, index in
            (maxValue << offsets[index]) + maxValues[index]
        }
        self.range = 0...maxValue
    }

    func isEncodable(_ values: [[Int]]) -> Bool {
        values.count == ranges.count
        && values.indices.allSatisfy { values[$0].allSatisfy(ranges[$0].contains) }
    }

    func encode(_ values: [Int]) -> Int {
        assert(values.count == ranges.count && values.indices.allSatisfy { ranges[$0].contains(values[$0]) })
        return values.indices.reduce(0) { encoded, index in
            (encoded << offsets[index]) + values[index] - ranges[index].lowerBound
        }
    }

    func decode(_ value: Int) -> [Int]? {
        assert(range.contains(value))
        var value = value
        var values = [Int]()
        let reverseOffsets = Array(offsets.dropFirst().reversed())
        let reverseRanges = Array(ranges.dropFirst().reversed())
        for index in reverseOffsets.indices {
            let mask = (1 << reverseOffsets[index]) - 1
            values.append((value & mask) + reverseRanges[index].lowerBound)
            value &>>= reverseOffsets[index]
        }
        values.append(value + ranges[0].lowerBound)
        values = values.reversed()
        for index in values.indices {
            guard ranges[index].contains(values[index]) else { return nil }
        }
        return values
    }
}
