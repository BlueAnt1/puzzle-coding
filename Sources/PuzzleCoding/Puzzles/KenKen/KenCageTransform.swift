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

    func encode(_ cells: [Cell]) -> [Int] {
        var values = Array(repeating: empty, count: size.gridCellCount)
        for (index, cell) in zip(cells.indices, cells) {
            guard case .cage(id: _, operator: let op?) = cell.clue else { continue }
            values[index] = op.operand
            if let operatorCell = operatorCell(for: index, in: cells) {
                values[operatorCell] = op.value
            }
        }
        return values
    }

    private func operatorCell(for index: Int, in cells: [Cell]) -> Int? {
        var next = index + 1
        if !next.isMultiple(of: size.rawValue)
            && cells[index].clue?.cageID == cells[next].clue?.cageID
        {
            return next
        }

        next = index + size.rawValue
        return next < cells.endIndex && cells[index].clue?.cageID == cells[next].clue?.cageID ? next : nil
    }

    func decode(shapes: [Int], contents: [Int]) throws -> [Clue] {
        var cells = shapes.map { Cell(clue: .cage(id: $0, operator: nil)) }
        var contents = contents

        for index in contents.indices where contents[index] != empty {
            let clueValue = contents[index]
            if let operatorCell = operatorCell(for: index, in: cells) {
                let operatorValue = contents[operatorCell]
                guard clueRange.contains(clueValue),
                      let op = Clue.Operator(value: operatorValue, operand: clueValue)
                else { throw Error.outOfRange }
                cells[index] = Cell(clue: Clue.cage(id: shapes[operatorCell], operator: op))
                contents[operatorCell] = empty
            } else {
                cells[index].clue = .cage(id: shapes[index], operator: .add(clueValue))
            }
        }

        return cells.map(\.clue!)
    }
}

extension Clue.Operator {
    init?(value: Int, operand: Int) {
//        guard operand > 0 else { return nil }
        switch value {
        case 1: self = .add(operand)
        case 2: self = .subtract(operand)
        case 3: self = .multiply(operand)
        case 4: self = .divide(operand)
        default: return nil
        }
    }
}
