//
//  Puzzle.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/11/24.
//

struct Encoder {

    func encodeSudoku(_ cells: [Cell]) throws -> String {
        guard let size = Size.allCases.first(where: { $0.gridCellCount == cells.count })
        else { throw Error.invalidSize }

        guard cells.allSatisfy({ $0.content.map { $0.isValid(in: size.valueRange) } ?? true })
        else { throw Error.outOfRange }

        let cellTransform = CellContentTransform(size: size)
        let fieldCoding = FieldCoding(range: cellTransform.range)
        return cells.map { cellTransform.encode($0.content) }.map(fieldCoding.encode).joined()
    }

    func encodeKillerJigsaw(_ cells: [Cell]) throws -> String {
        guard let size = Size.allCases.first(where: { $0.gridCellCount == cells.count })
        else { throw Error.invalidSize }

        let ranges = KillerJigsaw.ranges(for: size)
        for cell in cells {
            guard let cage = cell.cage,
                  let box = cell.box
            else { throw Error.missingData }

            guard cell.content.map({ $0.isValid(in: size.valueRange) }) ?? true,
                  ranges.cageShape.contains(cage.shape),
                  ranges.boxShape.contains(box.shape)
            else { throw Error.outOfRange }

            switch cage.content {
            case .clue(let clue) where !ranges.cageClue.contains(clue):
                throw Error.outOfRange
            case .operator(let op) where op != .add:
                throw Error.outOfRange
            default: break
            }
        }

        let cageTransform = CageContentTransform(size: size)
        let contentTransform = CellContentTransform(size: size)
        let shiftTransform = ShiftTransform(ranges: [ranges.boxShape,
                                                     ranges.cageShape,
                                                     cageTransform.range,
                                                     contentTransform.range])
        let fieldCoding = FieldCoding(range: shiftTransform.range)
        return cells.map { cell in
            shiftTransform.encode([cell.box!.shape,
                                   cell.cage!.shape,
                                   cageTransform.encode(cell.cage!.content),
                                   contentTransform.encode(cell.content)])
        }
        .map(fieldCoding.encode).joined()
    }
}

//protocol Puzzle {
//    var type: PuzzleType { get }
//    var size: Size { get }
//
//    var boxShapes: [Int]? { get }
//    var boxColors: [Int]? { get }
//
//    var cageContent: [CageContent]? { get }
//    var cageShapes: [Int]? { get }
//
//    var cellContent: [CellContent?] { get }
//}
//
//
//extension Puzzle {
//    var ranges: [PartialKeyPath<any Puzzle> : ClosedRange<Int>] {
//        [
//            \.boxShapes: type == .str8ts ? 0...1 : size.valueRange,
//             \.boxColors: 1...5,
//             \.cageContent: CageContentTransform(size: size).range,
//             \.cageShapes: 1...5,
//             \.cellContent: CellContentTransform(size: size).range
//        ]
//    }
//
//    var values: [[Int]] {
//        requirements.map { property in
//            switch property {
//            case \.boxShapes, \.boxColors, \.cageShapes:
//                return self[keyPath: property] as! [Int]
//            case \.cellContent:
//                let cellTransform = CellContentTransform(size: size)
//                return cellContent.map(cellTransform.encode)
//            case \.cageContent:
//                let cageTransform = CageContentTransform(size: size)
//                return cageContent!.map(cageTransform.encode)
//            default: fatalError("Invalid property")
//            }
//        }
//    }
//
//    typealias Requirement = PartialKeyPath<Puzzle>
//
//    private var requirements: [Requirement] {
//        switch type {
//        case .kendoku: [\.cageContent, \.cageShapes, \.cellContent]
//        case .kenken: [\.cageContent, \.cageShapes, \.cellContent]
//        case .killerJigsaw: [\.boxShapes, \.boxColors, \.cageContent, \.cageShapes, \.cellContent]
//        case .killerSudoku: [\.cageContent, \.cageShapes, \.cellContent]
//        case .jigsawSudoku: [\.boxShapes, \.boxColors, \.cellContent]
//        case .sudoku, .sudokuX, .windoku: [\.cellContent]
//        case .str8ts: [\.boxShapes, \.cellContent]
//        }
//    }
//}
//
