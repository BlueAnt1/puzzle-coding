//
//  KenCageTransform.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/21/24.
//

struct KenCageTransform {
    let size: Size

    var empty: Int { 0 }
    private var maximumClue: Int { size.rawValue * size.rawValue * size.rawValue * (size.rawValue - 1) * (size.rawValue - 2) }
    var clueRange: ClosedRange<Int> { 1...min(1023, maximumClue) }
    var range: ClosedRange<Int> { empty...clueRange.upperBound }

    private func left(_ index: Int) -> Int? {
        guard index > 0 else { return nil }
        let left = index - 1
        // same row
        guard index / size.rawValue == left / size.rawValue else { return nil }
        return left
    }

    private func above(_ index: Int) -> Int? {
        guard index >= size.rawValue else { return nil }
        let above = index - size.rawValue
        return above
    }

    private func isSingleCell(_ index: Int, in shapes: [Int]) -> Bool {
        let left = left(index)
        let above = above(index)
        let right = (index + 1).isMultiple(of: size.rawValue) ? nil : index + 1
        let below = (index + size.rawValue) > size.gridCellCount ? nil : index + size.rawValue
        return (left == nil || shapes[left!] != shapes[index])
        && (above == nil || shapes[above!] != shapes[index])
        && (right == nil || shapes[right!] != shapes[index])
        && (below == nil || shapes[below!] != shapes[index])
    }

    func encode(_ cells: [CageInfo]) -> [Int] {
        zip(cells.indices, cells).map { (index, info) in
            if let clue = info.clue {
                clue.value
            } else if let left = left(index),
                      cells[left].cage == info.cage,
                      let op = cells[left].clue?.operator
            {
                op
            } else if let above = above(index),
                      cells[above].cage == info.cage,
                      let op = cells[above].clue?.operator
            {
                op
            } else {
                empty
            }
        }
    }

    func decode(shapes: [Int], contents: [Int]) throws -> [CageInfo] {
        var cages = shapes.map { CageInfo(cage: $0) }

        for (index, content) in zip(contents.indices, contents) where content != empty {
            if let left = left(index),
               cages[left] == cages[index],
               let clue = CageInfo.Clue(operator: content, value: contents[left])
            {
                cages[left].clue = clue
            } else if let above = above(index),
                      cages[above] == cages[index],
                      let clue = CageInfo.Clue(operator: content, value: contents[above])
            {
                cages[above].clue = clue
            } else if isSingleCell(index, in: shapes) {
                cages[index].clue = .add(content)
            }
        }
        guard cages.allSatisfy({ $0.clue.map { clueRange.contains($0.value) } ?? true }) else { throw Error.outOfRange }
        return cages
    }
}
