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

    @Test
    func testKillerSudokuMyTranslationOfGentleExample1() throws {
        let raw = KillerSudoku.gentleExample1.encode(using: .versionB)
        let decoded = try #require(KillerSudoku.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
        #expect(decoded.puzzle == KillerSudoku.gentleExample1)
    }

    @Test
    func testKillerSudoku() throws {
        let raw = "L9B0jdd00ep1jpt1ez50du900ep1g5n08b500ep00ep00ep1ez509w11mvl1ez53bpt2tjl2tjl1rm92zgx00ep00ep31g10g7l1t752tjl0ikx1ez505xt1rm92tjl2tjl00ep1ez51ez500ep1ez500ep1ez54nwx484100ep31g11ez500ep0ff51jbj05xt00ep484100ep2tjl4hld00ep00ep3ci92tjl1qtt2wpd2tjl04cx48411no100ep2tjl2tjl1ez54hld484100ep3dap1ez500ep2tjl0aoh00ep00ep2tjl2tjl2tjl1ez5"
        let myRaw = KillerSudoku.gentleExample1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(KillerSudoku.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == KillerSudoku.gentleExample1)
    }

    @Test(.disabled("Not implemented at SudokuWiki yet"))
    func testKillerJigsaw() throws {
        let raw = ""
        let decoded = try #require(KillerJigsaw.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
    }

    @Test
    func testKenKenMyTranslationOfVeryEasy1() throws {
        let raw = KenKen.veryEasy1.encode(using: .versionB)
        let decoded = try #require(KenKen.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)
        #expect(decoded.puzzle == KenKen.veryEasy1)
    }

    @Test
    func testKenKen() throws {
        let raw = "K6B04sr00nf5qa3030r5vt701mz5op7bakr5mx700nf5mx700975mx7b8srb8ln00235mbvbeiz5mbvgw23gvgrguvfb8lnb96z02ff00975pvv5mx75mbv01fv0023bmtnb96zb8ln00230097"
        let myRaw = KenKen.veryEasy1.encode(using: .versionB)
        #expect(raw == myRaw)
        let decoded = try #require(KenKen.decode(raw))
        print(Grid(decoded.puzzle))
        let encoded = decoded.puzzle.encode(using: decoded.version)
        #expect(raw == encoded)

        #expect(decoded.puzzle == KenKen.veryEasy1)
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
