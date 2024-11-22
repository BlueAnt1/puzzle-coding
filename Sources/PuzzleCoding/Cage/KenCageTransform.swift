//
//  KenCageTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/21/24.
//

struct KenCageTransform {
    private static var clueLimit: Int { 2047 }
    let size: Size

    private var empty: Int { 0 }
    private var maximumClue: Int { size.rawValue * size.rawValue * size.rawValue * (size.rawValue - 1) * (size.rawValue - 2) }
    var clueRange: ClosedRange<Int> { 1...min(Self.clueLimit, maximumClue) }
    var range: ClosedRange<Int> { empty...clueRange.upperBound }

    func encode(_ cells: [CageInfo]) -> [Int] {
        var values = Array(repeating: empty, count: size.gridCellCount)
        for (index, info) in zip(cells.indices, cells) {
            guard let clue = info.clue else { continue }
            values[index] = clue.value
            if let operatorCell = operatorCell(for: index, in: cells) {
                values[operatorCell] = clue.operatorValue
            }
        }
        return values
    }

    private func operatorCell(for index: Int, in cells: [CageInfo]) -> Int? {
        var next = index + 1
        if !next.isMultiple(of: size.rawValue)
            && cells[index].cage == cells[next].cage
        {
            return next
        }

        next = index + size.rawValue
        guard next < cells.endIndex, cells[index].cage == cells[next].cage else { return nil }
        return next
    }

    func decode(shapes: [Int], contents: [Int]) throws -> [CageInfo] {
        var cages = shapes.map { CageInfo(cage: $0) }
        var contents = contents

        for index in contents.indices where contents[index] != empty {
            let clueValue = contents[index]
            if let operatorCell = operatorCell(for: index, in: cages) {
                let operatorValue = contents[operatorCell]
                guard let clue = CageInfo.Clue(operator: operatorValue, value: clueValue) else { throw Error.outOfRange }
                cages[index].clue = clue
                contents[operatorCell] = empty
            } else {
                cages[index].clue = .add(clueValue)
            }
        }

        guard cages.allSatisfy({ $0.clue.map { clueRange.contains($0.value) } ?? true }) else { throw Error.outOfRange }
        return cages
    }
}
