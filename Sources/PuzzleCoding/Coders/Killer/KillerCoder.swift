//
//  KillerCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

struct KillerCoder {
    let size: Size
    let shapeRanges: [ClosedRange<Int>]
    let clues: [Int]
    let shapes: [[Int]]
}

extension KillerCoder {
    init?(size: Size, shapeRanges: [ClosedRange<Int>], rawValue: String) {
        let pattern = KillerPattern(size: size, shapeRanges: shapeRanges)
        guard let match = try? pattern.regex.wholeMatch(in: rawValue), let output = match.output
        else { return nil }
        self.size = size
        self.shapeRanges = shapeRanges
        clues = output.clues
        shapes = output.shapes
    }

    var rawValue: String {
        let killerCoding = KillerCoding(size: size, shapeRanges: shapeRanges)
        let values = killerCoding.encode(clues: clues, shapes: shapes)
        return FieldCoding(range: killerCoding.range, radix: PuzzleCoding.radix).encode(values)
    }
}


