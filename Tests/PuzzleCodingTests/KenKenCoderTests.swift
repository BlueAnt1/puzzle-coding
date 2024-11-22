//
//  KenKenCoderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/24/24.
//

import Testing
@testable import PuzzleCoding


struct KenKenCoderTests {

    @Test(arguments: KenKen.Version.allCases)
    func coderRoundtrips(version: KenKen.Version) throws {
        var puzzle = KenKen.veryEasy1
        puzzle.version = version
        let rawPuzzle = puzzle.rawValue

        let decoded = try #require(KenKen(rawValue: rawPuzzle))

        #expect(decoded == puzzle)

        let puzzleCount = Double(rawPuzzle.count)
        print("""
            \(puzzle) \(version)
            \(rawPuzzle)
            puzzleCoding.count = \(puzzleCount.formatted(.number.precision(.fractionLength(0))))
            """)
    }

    @Test(arguments: [PuzzleType.kenken, .kendoku])
    func kenTypeRoundTrips(_ type: PuzzleType) async throws {
        let cells = KenKen.veryEasy1
        switch type {
        case .kenken:
            let puzzle = try #require(try KenKen(cells: cells))
            let raw = puzzle.rawValue
            let decoded = try #require(KenKen(rawValue: raw))
            #expect(decoded == puzzle)
        case .kendoku:
            let puzzle = try #require(try KenDoku(cells: cells))
            let raw = puzzle.rawValue
            let decoded = try #require(KenDoku(rawValue: raw))
            #expect(decoded == puzzle)
        default: fatalError()
        }
    }

//    @Test
//    func sizes() {
//        for size in Size.allCases {
//            let ranges = KenKen.ranges(for: size)
//            let shiftTransform = ShiftTransform(ranges: ranges.cageShape, ranges.cageContent, ranges.cellContent)
//            let fieldCoding = FieldCoding(range: shiftTransform.range)
//        }
//    }
//    @Test
//    func maximums() {
//        for size in Size.allCases {
//            let s = size.rawValue
//            let maxValue = s * s * s * (s - 1) * (s - 2)
//            print("\(size) \(maxValue)")
//        }
//    }
}
