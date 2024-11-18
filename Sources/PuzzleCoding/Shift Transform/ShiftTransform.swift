//
//  ShiftTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

/// Generic shift transform.
struct ShiftTransform {
    private let ranges: [ClosedRange<Int>]
    private let shifts: [Int]
    let range: ClosedRange<Int>

    init(ranges first: ClosedRange<Int>, _ rest: ClosedRange<Int>...) {
        self.init(ranges: [first] + rest)
    }

    init(ranges: [ClosedRange<Int>]) {
        assert(!ranges.isEmpty && ranges.allSatisfy { $0.lowerBound >= 0 })
        self.ranges = ranges

        let maxValues = ranges.map { $0.upperBound - $0.lowerBound }
        let shifts = [0] + maxValues.dropFirst().map { String($0, radix: 2).count }
        self.shifts = shifts
        let maxValue = zip(shifts, maxValues).reduce(0) { maxValue, offsetMax in
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
            (encoded << shifts[index]) + values[index] - ranges[index].lowerBound
        }
    }

    func decode(_ value: Int) throws -> [Int] {
        guard range.contains(value) else { throw Error.outOfRange }
        var value = value
        var values = [Int]()
        for (offset, range) in zip(shifts.reversed(), ranges.reversed()) {
            if offset > 0 {
                let mask = (1 << offset) - 1    // a contiguous bunch of 1 bits
                values.append((value & mask) + range.lowerBound)
                value &>>= offset
            } else {
                values.append(value + range.lowerBound)
            }
        }
        values = values.reversed()
        guard zip(ranges, values).allSatisfy({ $0.contains($1) }) else { throw Error.outOfRange }
        return values
    }
}


