//
//  ShiftedKillerTransform.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

struct ShiftedKillerTransform {
    private let shapeRanges: [ClosedRange<Int>]
    private let clueRange: ClosedRange<Int>
    private let shiftTransform: ShiftTransform

    init(size: Size, shapeRanges: [ClosedRange<Int>]) {
        self.shapeRanges = shapeRanges

        let clueRange = 0...size.valueRange.reduce(0, +)
        self.clueRange = clueRange
        self.shiftTransform = ShiftTransform(ranges: [clueRange] + shapeRanges)
    }

    var range: ClosedRange<Int> { shiftTransform.range }

    func isEncodable(clues: [Int], shapes: [[Int]]) -> Bool {
        shiftTransform.isEncodable([clues] + shapes)
    }

    private func encode(clue: Int, shapes: [Int]) -> Int {
        shiftTransform.encode([clue] + shapes)
    }

    private func decode(_ value: Int) -> (clue: Int, shapes: [Int])? {
        guard range.contains(value) else { return nil }
        guard let decoded = shiftTransform.decode(value) else { return nil }
        return (decoded[0], Array(decoded[1...]))
    }

    func encode(clues: [Int], shapes: [[Int]]) -> [Int] {
        clues.indices.map { index in
            encode(clue: clues[index], shapes: shapes.map { $0[index] })
        }
    }

    func decode(_ values: [Int]) -> (clues: [Int], shapes: [[Int]])? {
        var clues = [Int]()
        var shapes = Array(repeating: [Int](), count: shapeRanges.count)
        for value in values {
            guard let decoded = decode(value) else { return nil }
            clues.append(decoded.clue)
            shapes.indices.forEach { shapes[$0].append(decoded.shapes[$0]) }
        }
        return (clues, shapes)
    }
}
