//
//  CageCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/31/24.
//

struct CageCoder {
    let size: Size
    let clues: [Int]
    let shapes: [Int]
}

extension CageCoder {
    init?(size: Size, rawValue: String) {
        let pattern = CagePattern(size: size)
        guard let match = try? pattern.regex.wholeMatch(in: rawValue) else { return nil }
        self.size = size
        clues = match.output.clues
        shapes = match.output.shapes
    }

    var rawValue: String {
        let cageCoding = CageCoding(size: size)
        let cages = cageCoding.encode(clues: clues, shapes: shapes)
        return FieldCoding(range: cageCoding.range, radix: PuzzleCoding.radix).encode(cages)
    }
}
