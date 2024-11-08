//
//  ShiftTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

/// Generic shift transform.
struct ShiftTransform {
    private let ranges: [ClosedRange<Int>]
    private let offsets: [Int]
    let range: ClosedRange<Int>

    init(ranges: [ClosedRange<Int>]) {
        assert(!ranges.isEmpty && ranges.allSatisfy { $0.lowerBound >= 0 })
        self.ranges = ranges

        let maxValues = ranges.map { $0.upperBound - $0.lowerBound }
        let offsets = [0] + maxValues.dropFirst().map { String($0, radix: 2).count }
        self.offsets = offsets
        let maxValue = zip(offsets, maxValues).reduce(0) { maxValue, offsetMax in
            (maxValue << offsetMax.0) + offsetMax.1
        }
        self.range = 0...maxValue
    }

    func isEncodable(_ values: [Int]) -> Bool {
        ranges.count == values.count
        && zip(ranges, values).allSatisfy { $0.contains($1) }
    }

    /// Pack values into a single value
    func encode(_ values: [Int]) -> Int {
        assert(isEncodable(values))
        return values.indices.reduce(0) { encoded, index in
            (encoded << offsets[index]) + values[index] - ranges[index].lowerBound
        }
    }

    func decode(_ value: Int) -> [Int]? {
        assert(range.contains(value))
        var value = value
        var values = [Int]()
        for (offset, range) in zip(offsets.reversed(), ranges.reversed()) where offset > 0 {
            let mask = (1 << offset) - 1    // a contiguous bunch of 1 bits
            values.append((value & mask) + range.lowerBound)
            value &>>= offset
        }
        values.append(value + ranges[0].lowerBound)
        values = values.reversed()
        for (range, value) in zip(ranges, values) {
            guard range.contains(value) else { return nil }
        }
        return values
    }
}


