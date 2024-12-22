//
//  RectangularRegions.swift
//  PuzzleCoding
//
//  Created by Quintin May on 12/22/24.
//

struct RectangularRegions: RandomAccessCollection {
    private let regions: [Int]

    init?(size: Size) {
        guard let (boxRowCount, boxColumnCount) = size.boxDimensions else { return nil }
        let row = (0 ..< size.rawValue).map { $0 / boxColumnCount }
        var regions = [Int]()
        for band in stride(from: 1, through: size.rawValue, by: boxRowCount) {
            for _ in 0 ..< boxRowCount {
                regions.append(contentsOf: row.map { $0 + band })
            }
        }
        self.regions = regions
    }

    var startIndex: Int { regions.startIndex }
    var endIndex: Int { regions.endIndex }
    subscript(_ position: Int) -> Int {
        regions[position]
    }
}

extension Size {
    var boxDimensions: (rows: Int, column: Int)? {
        switch rawValue {
        case 6: (2, 3)
        case 8: (2, 4)
        case 9: (3, 3)
        case 16: (4, 4)
        case 25: (5, 5)
        default: nil
        }
    }
}
