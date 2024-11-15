//
//  SudokuWikiCompatibilityTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
@testable import PuzzleCoding



struct SudokuWikiCompatibilityTests {
    @Test
    func testSudoku() throws {
        let raw = "S9B03epep090607epep01ep04ep03ep02ep08epep02epepepepep07epep07epepepepep09epepepep080703epepep05epepep01epepep03epep0407ep0501epep09ep05epepep02ep0708epep060201epep04"
        let decoded = try #require(Sudoku.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func testSudokuX() throws {
        let raw = "X9B04epep08ep0502epepepepepepepepepepepep08epep07epepepepepepep02ep0809ep07epepepepepepepep0401ep0503epepepepepepepepepepepep01epepepepepepepepepepepep01epep07epep06"
        let decoded = try #require(SudokuX.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func testWindoku() throws {
        let raw = "W9B080603epepepepepepepepepepepepepep04ep04epep05ep0306epep03epep06epep09epep05ep04ep03ep08epep07epep09epep05epep0904ep02epep03ep05epepepepepepepepepepepepepep060205"
        let decoded = try #require(Windoku.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }


    @Test //(.disabled("Doesn't decode correctly"))
    func testKillerSudoku() throws {
        let raw = "L9B00jdd000ep01jpt0cnip0bmdt0b8y90nx8r0mpe90mhht000ep000ep01ez50bifl0cvf50cnip0pssx0pamp0pamp01rm902zgx000ep0b8y90e9zl0bor50oaa90pamp0mzo10z4lt0xvkh0zh8x1brpt1brpt18ykx1llox1llox1k74h0z4lt0xq1d0z4lt1dm351d6a918ykx1n85t1llox1k74h0y51t0z8y70xvkh18ykx1d6a918ykx1n09d1oob51k74h1vfo11yrrl1y8sx28emp29ki929hch2i0pd2m4gh2jk0h1vfo11y8sx1y8sx282s12b5e92avwx2hwr52l9n52jbbl1vfo11y8sx1vpxt26o7l26o7l29hch2kpw12kpw12jbbl"
        let myRaw = KillerSudoku.gentleExample1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(KillerSudoku.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == KillerSudoku.gentleExample1)
    }
/*
 #expect(decoded.puzzle == KillerJigsaw.actualPuzzle)

 */
    @Test(.disabled("Not implemented at SudokuWiki yet"))
    func testKillerJigsaw() throws {
        let raw = ""
        let decoded = try #require(KillerJigsaw.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }
}

//private extension FixedWidthInteger {
//    var bytes: [UInt8] {
//        withUnsafeBytes(of: bigEndian, Array.init)
//    }
//}
//
//import Foundation
//
//struct Foo {
//    func test() {
//        let value: UInt64 = 123
//        let bytes: [UInt8] = value.bytes
//        var data = Data()
//        data.append(contentsOf: bytes)
//        let b64 = data.base64EncodedString()
//    }
//}
