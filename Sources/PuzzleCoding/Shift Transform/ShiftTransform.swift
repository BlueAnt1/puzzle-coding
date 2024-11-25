//
//  ShiftTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

/// Generic shift transform.
struct ShiftTransform {
    private let ranges: [ClosedRange<Int>]
    private let bitCounts: [Int]
    let range: ClosedRange<Int>

    init(ranges first: ClosedRange<Int>, _ rest: ClosedRange<Int>...) {
        self.init(ranges: [first] + rest)
    }

    init(ranges: [ClosedRange<Int>]) {
        assert(!ranges.isEmpty && ranges.allSatisfy { $0.lowerBound >= 0 })
        self.ranges = ranges

        let maxValues = ranges.map { $0.upperBound - $0.lowerBound }
        self.bitCounts = maxValues.map { String($0, radix: 2).count }
        let maxValue = zip(bitCounts, maxValues).reduce(0) { maxValue, bitCountMax in
            (maxValue << bitCountMax.0) + bitCountMax.1
        }
        self.range = 0...maxValue
    }

    func isEncodable(_ values: [Int]) -> Bool {
        ranges.count == values.count
        && zip(ranges, values).allSatisfy { $0.contains($1) }
    }

    func encode(_ values: [Int]) -> Int {
        assert(isEncodable(values))
        return values.indices.reduce(0) { encoded, index in
            (encoded << bitCounts[index]) + values[index] - ranges[index].lowerBound
        }
    }

    func decode(_ value: Int) throws -> [Int] {
        guard range.contains(value) else { throw Error.outOfRange }
        var value = value
        var values = [Int]()
        for (bitCount, range) in zip(bitCounts.reversed(), ranges.reversed()) {
            let mask = (1 << bitCount) - 1    // a contiguous bunch of 1 bits
            values.append((value & mask) + range.lowerBound)
            value &>>= bitCount
        }
        values = values.reversed()
        guard zip(ranges, values).allSatisfy({ $0.contains($1) }) else { throw Error.outOfRange }
        return values
    }
}


