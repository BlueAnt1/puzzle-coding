//
//  KillerCageTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct KillerCageTransform {
    let size: Size

    var empty: Int { 0 }
    var clueRange: ClosedRange<Int> { empty...size.valueRange.reduce(0, +) }
    var range: ClosedRange<Int> { clueRange }

    func encode(_ cells: [CageInfo]) -> [Int] {
        cells.map { $0.clue?.value ?? empty }
    }

    func decode(shapes: [Int], contents: [Int]) throws -> [CageInfo] {
        let cages = zip(shapes, contents).map { cage, content in
            content == empty ? CageInfo(cage: cage) : CageInfo(cage: cage, clue: .add(content))
        }
        guard cages.allSatisfy({ $0.clue.map { clueRange.contains($0.value) } ?? true }) else { throw Error.outOfRange }
        return cages
    }
}
