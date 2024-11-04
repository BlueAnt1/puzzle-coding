//
//  ShiftedKillerCoding.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

struct ShiftedKillerCoding {
    let size: Size
    let shapeRanges: [ClosedRange<Int>]

    init(size: Size, shapeRanges: [ClosedRange<Int>]) {
        self.size = size
        self.shapeRanges = shapeRanges
    }

    private var clueRange: ClosedRange<Int> { 0...size.valueRange.reduce(0, +) }
    private var offsets: [Int] { shapeRanges.map { String($0.upperBound, radix: 2).count }}

    var range: ClosedRange<Int> {
        let offsets = offsets
        let maxValue = shapeRanges.indices.reduce(clueRange.upperBound) { maxValue, rangeIndex in
            (maxValue << offsets[rangeIndex]) + shapeRanges[rangeIndex].upperBound
        }
        return 0...maxValue
    }

    func checkPreconditions(clues: [Int], shapes: [[Int]]) {
        // sizes
        precondition(size.gridCellCount == clues.count)
        precondition(shapeRanges.count == shapes.count)
        precondition(shapes.allSatisfy { clues.count == $0.count})
        // values
        precondition(clues.allSatisfy(clueRange.contains))
        for (shapeRange, shapes) in zip(shapeRanges, shapes) {
            precondition(shapeRange.lowerBound == 1)
            precondition(shapes.allSatisfy(shapeRange.contains))
        }
    }

    func encode(clues: [Int], shapes: [[Int]]) -> [Int] {
        let offsets = offsets
        let values = clues.indices
            .map { clueIndex in
                var value = clues[clueIndex]
                for shapeIndex in offsets.indices {
                    value = (value << offsets[shapeIndex]) + shapes[shapeIndex][clueIndex] - 1
                }
                return value
            }

        return values
    }

    func decode(from values: [Int]) -> (clues: [Int], shapes: [[Int]])? {
        guard (values.count == size.gridCellCount) else { return nil }
        let offsets = offsets
        var clues = [Int]()
        var outputShapes = Array(repeating: [Int](), count: shapeRanges.count)

        for var value in values {
            var shapes = [Int]()
            for offset in offsets.reversed() {
                let mask = (1 << offset) - 1
                shapes.append((value & mask) + 1)
                value &>>= offset
            }
            clues.append(value)
            shapes = shapes.reversed()
            for index in shapes.indices {
                outputShapes[index].append(shapes[index])
            }
        }

        guard clues.allSatisfy(clueRange.contains) else { return nil }
        for index in shapeRanges.indices {
            guard outputShapes[index].allSatisfy(shapeRanges[index].contains) else { return nil }
        }
        return (clues, outputShapes)
    }
}
