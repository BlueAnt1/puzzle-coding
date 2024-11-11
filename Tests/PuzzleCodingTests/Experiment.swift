//
//  Experiment.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/8/24.
//

import Testing
@testable import PuzzleCoding
import Foundation

struct ExperimentNoOptimization {
    @Test
    func analyze() {
        let sizes = Size.allCases   // [Size.grid9x9]
        let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
        print("Size", "Puzzle", "Range", "Bits", "FieldWidth32", "FieldWidth36", separator: "\t")
        for size in sizes {
            let puzzle = Puzzle(size: size)
            for type in puzzles {
                let ranges = type.requirements.map { puzzle.ranges[$0]! }
                let transform = ShiftTransform(ranges: ranges)
                let bitCount = String(transform.range.upperBound, radix: 2).count
                let fieldWidth32 = String(transform.range.upperBound, radix: 32).count
                let fieldWidth36 = String(transform.range.upperBound, radix: 36).count
                print(size, type, transform.range, bitCount, fieldWidth32, fieldWidth36, separator: "\t")
            }
        }
    }

    enum PuzzleType: CaseIterable {
        typealias Requirement = KeyPath<Puzzle, [Int]?>
        typealias Requirements = [Requirement]

        case kendoku, kenken, killerJigsaw, killerSudoku, jigsawSudoku, sudoku

        var requirements: Requirements {
            switch self {
            case .kendoku: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .kenken: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .killerJigsaw: [\.boxShapes, \.boxColors, \.cageClues, \.cageShapes, \.progress]
            case .killerSudoku: [\.cageClues, \.cageShapes, \.progress]
            case .jigsawSudoku: [\.clues, \.boxShapes, \.boxColors, \.progress]
            case .sudoku: [\.clues, \.progress]
            }
        }
    }

    struct Puzzle {
        let size: Size
        var clues: [Int]? = nil
        var boxShapes: [Int]? = nil
        var boxColors: [Int]? = nil
        var cageClues: [Int]? = nil
        var cageShapes: [Int]? = nil
        var clueOperator: [Int]? = nil
        var progress: [Int]? = nil

        var ranges: [KeyPath<Puzzle, [Int]?> : ClosedRange<Int>] {
            [
                \.clues: 0...size.valueRange.upperBound,
                 \.boxShapes: size.valueRange,
                 \.boxColors: 1...5,
                 \.cageClues: 0...size.valueRange.reduce(0, +),
                 \.cageShapes: 1...5,
                 \.clueOperator: 1...4,
                 \.progress: 0...(size.valueRange.upperBound + size.valueRange.bitValue)    // solution & candidates
            ]
        }
    }
}

private enum Experiment {
    enum PuzzleType: CaseIterable {
        typealias Requirement = KeyPath<Puzzle, [Int]?>
        typealias Requirements = [Requirement]

        case kendoku, kenken, killerJigsaw, killerSudoku, jigsawSudoku, sudoku

        var requirements: Requirements {
            switch self {
            case .kendoku: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .kenken: [\.cageClues, \.cageShapes, \.clueOperator, \.progress]
            case .killerJigsaw: [\.boxShapes, \.boxColors, \.cageClues, \.cageShapes, \.progress]
            case .killerSudoku: [\.cageClues, \.cageShapes, \.progress]
            case .jigsawSudoku: [\.boxShapes, \.boxColors, \.progress]
            case .sudoku: [\.progress]
            }
        }
    }

    struct Puzzle {
        let size: Size
        var clues: [Int]? = nil
        var boxShapes: [Int]? = nil
        var boxColors: [Int]? = nil
        var cageClues: [Int]? = nil
        var cageShapes: [Int]? = nil
        var clueOperator: [Int]? = nil
        var progress: [Int]? = nil

        var ranges: [KeyPath<Puzzle, [Int]?> : ClosedRange<Int>] {
            [
                \.clues: 0...size.valueRange.upperBound,
                 \.boxShapes: size.valueRange,
                 \.boxColors: 1...5,
                 \.cageClues: 0...size.valueRange.reduce(0, +),
                 \.cageShapes: 1...5,
                 \.clueOperator: 1...4,
                 \.progress: CellContentTransform(size: size).range
            ]
        }
    }
}

extension Experiment {
    struct ClueWithProgressBase36 {
        @Test
        func analyze() {
            let sizes = Size.allCases   // [Size.grid9x9]
            let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
            print("Size", "Puzzle", "Range", "Bits", "Field Width", "Encoding", separator: "\t")
            for size in sizes {
                let puzzle = Puzzle(size: size)
                for type in puzzles {
                    let ranges = type.requirements.map { puzzle.ranges[$0]! }
                    let transform = ShiftTransform(ranges: ranges)
                    let bitCount = String(transform.range.upperBound, radix: 2).count
                    let fieldWidth = String(transform.range.upperBound, radix: 36).count
                    let encodingCount = fieldWidth * size.gridCellCount
                    print(size, type, transform.range, bitCount, fieldWidth, encodingCount, separator: "\t")
                }
            }
        }
    }
}

extension Experiment {
    struct PackMultipleCellsIntoOneInt {
        @Test
        func analyze() {
            let sizes = Size.allCases   // [Size.grid9x9]
            let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
            print("Size", "Puzzle", "Range", "Bits", "Pack", "Field Width", "Encoding", separator: "\t")
            for size in sizes {
                let puzzle = Puzzle(size: size)
                for type in puzzles {
                    let ranges = type.requirements.map { puzzle.ranges[$0]! }
                    let transform = ShiftTransform(ranges: ranges)
                    let bitCount = String(transform.range.upperBound, radix: 2).count
                    let (packCount, extra) = 64.quotientAndRemainder(dividingBy: bitCount)
                    let upperBound: UInt64 = (1...packCount).reduce(0) { result, _ in (result << UInt64(bitCount)) + UInt64(transform.range.upperBound) }

                    let fieldWidth = String(upperBound, radix: 36).count
                    let encodingCount = fieldWidth * (size.gridCellCount / packCount + extra.signum())
                    print(size, type, transform.range, bitCount, packCount, fieldWidth, encodingCount, separator: "\t")
                }
            }
        }
    }
}

private extension UInt64 {
    var littleEndianBytes: [UInt8] {
        var bytes = [UInt8]()
        var value = self.bigEndian  // reverse
        while bytes.count < 8 {
            bytes.append(UInt8(value & 0xff))
            value &>>= 8
        }
        return bytes
    }
}

extension Experiment {
    struct CompressB64 {
        @Test
        func analyze() {
            let sizes = Size.allCases   // [Size.grid9x9]
            let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
            print("Size", "Puzzle", "Range", "Bits", "Encoding", separator: "\t")
            for size in sizes {
                let puzzle = Puzzle(size: size)
                for type in puzzles {
                    let ranges = type.requirements.map { puzzle.ranges[$0]! }
                    let transform = ShiftTransform(ranges: ranges)
                    let bitCount = String(transform.range.upperBound, radix: 2).count

                    var encodingCountAverage: Int {
                        var counts = [Int]()
                        for _ in 0 ..< 100 {
                            let bytes = (0..<size.gridCellCount).flatMap { _ in UInt64(transform.range.randomElement()!).littleEndianBytes }
                            let data = Data(bytes)
                            let compressed = try! (data as NSData).compressed(using: .zlib) as Data
                            let b64 = compressed.base64EncodedString()
                            counts.append(b64.count)
                        }
                        return counts.reduce(0, +) / counts.count
                    }

                    print(size, type, transform.range, bitCount, encodingCountAverage, separator: "\t")
                }
            }
        }
    }
}

extension Experiment {
    struct CompressB36 {
        @Test
        func analyze() {
            let sizes = Size.allCases   // [Size.grid9x9]
            let puzzles = PuzzleType.allCases   // [PuzzleType.sudoku]
            print("Size", "Puzzle", "Range", "Bits", "Encoding", separator: "\t")
            for size in sizes {
                let puzzle = Puzzle(size: size)
                for type in puzzles {
                    let ranges = type.requirements.map { puzzle.ranges[$0]! }
                    let transform = ShiftTransform(ranges: ranges)
                    let bitCount = String(transform.range.upperBound, radix: 2).count

                    var encodingCountAverage: Int {
                        var counts = [Int]()
                        for _ in 0 ..< 100 {
                            let bytes = (0..<size.gridCellCount).flatMap { _ in UInt64(transform.range.randomElement()!).littleEndianBytes }
                            let data = Data(bytes)
                            let compressed = try! (data as NSData).compressed(using: .zlib) as Data
                            // UInt64.max, base 36, field width = 13 characters
                            let (ints, extra) = compressed.count.quotientAndRemainder(dividingBy: 8)  // 8 bytes per Int
                            let encodingCount = (ints + extra.signum()) * 13
                            counts.append(encodingCount)
                        }
                        return counts.reduce(0, +) / counts.count
                    }

                    print(size, type, transform.range, bitCount, encodingCountAverage, separator: "\t")
                }
            }
        }
    }
}
