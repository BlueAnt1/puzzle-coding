//
//  ShiftedKillerCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/1/24.
//

struct ShiftedKillerCoder {
    let size: Size
    let shapeRanges: [ClosedRange<Int>]
    let clues: [Int]
    let shapes: [[Int]]
}

extension ShiftedKillerCoder {
    init?(size: Size, shapeRanges: [ClosedRange<Int>], rawValue: String) {
        let pattern = ShiftedKillerPattern(size: size, shapeRanges: shapeRanges)
        guard let match = try? pattern.regex.wholeMatch(in: rawValue), let output = match.output
        else { return nil }
        self.size = size
        self.shapeRanges = shapeRanges
        clues = output.clues
        shapes = output.shapes
    }

    var rawValue: String {
        let coding = ShiftedKillerCoding(size: size, shapeRanges: shapeRanges)
        let encoded = coding.encode(clues: clues, shapes: shapes)
        let fieldCoding = FieldCoding(range: coding.range, radix: PuzzleCoding.radix)
        return encoded.map(fieldCoding.encode).joined()
    }
}


