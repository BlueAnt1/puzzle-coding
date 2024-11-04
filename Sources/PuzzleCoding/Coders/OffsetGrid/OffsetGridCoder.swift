//
//  OffsetGridCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

struct OffsetGridCoder {
    let grid: Grid
}

extension OffsetGridCoder {
    init?(size: Size, rawValue: String) {
        let pattern = OffsetGridPattern(size: size)
        guard let match = try? pattern.regex.wholeMatch(in: rawValue) else { return nil }
        self.init(grid: match.output.1)
    }

    var rawValue: String {
        let offsetCoding = OffsetGridCoding(size: grid.size)
        let fieldCoding = FieldCoding(range: offsetCoding.range, radix: PuzzleCoding.radix)

        return grid.reduce(into: "") { rawValue, content in
            rawValue.append(fieldCoding.encode(offsetCoding.encode(content)))
        }
    }
}
