//
//  CageCoding.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/31/24.
//

struct CageCoding {
    let size: Size

    func encode(clues: [Int], shapes: [Int]) -> [Int] {
        clues.indices.map { encode(clue: clues[$0], shape: shapes[$0]) }
    }

    func decode(_ values: [Int]) -> (clues: [Int], shapes: [Int]) {
        let decoded = values.map(decode)
        return (decoded.map(\.0), decoded.map(\.1))
    }
    
    private func encode(clue: Int, shape: Int) -> Int {
        clue << 3 + shape - 1
    }

    private func decode(_ value: Int) -> (clue: Int, shape: Int) {
        (value >> 3, value & 0b111 + 1)
    }

    private var maxCageValue: Int {
        let maxCageClue = size.valueRange.reduce(0, +) << 3
        return maxCageClue + 0b111
    }

    var range: ClosedRange<Int> { 0...maxCageValue }
}
