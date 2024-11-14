//
//  SudokuWikiTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/4/24.
//

import Testing
import PuzzleCoding

//struct SudokuWikiTests {
//    @Test
//    func testSudoku() throws {
//        let raw = "S9B030e0h0906070q0s013j049j030e029i089i1i029i0a4i0qae07a21l071p120d1i6209641t8j9l0807032a1t2405ci9i0b019i7q1q030k0f04078m05010mci090j050d0m0h021m07080c0g0602018i0e04"
//        let decoded = try #require(Sudoku.decode(raw))
//        //print(decoded.puzzle.grid)
//        let encoded = decoded.puzzle.encode(using: decoded.version)
//        #expect(raw == encoded)
//    }
//
//    @Test
//    func testSudokuX() throws {
//        let raw = "X9B049ibi089m0502bm0ac40abk9q9o108ebqd6a4080c9r070t1q9q921m1u1q020a08090e07co8ock0g0e0f0a4o04010g05030d0i5i5k4kg8agbsaado106i01d8g89sfsabdo117e6id88k9g019aco075ed006"
//        let decoded = try #require(SudokuX.decode(raw))
//        //print(decoded.puzzle.grid)
//        let encoded = decoded.puzzle.encode(using: decoded.version)
//        #expect(raw == encoded)
//    }
//}

private extension FixedWidthInteger {
    var bytes: [UInt8] {
        withUnsafeBytes(of: bigEndian, Array.init)
    }
}

import Foundation

struct Foo {
    func test() {
        let value: UInt64 = 123
        let bytes: [UInt8] = value.bytes
        var data = Data()
        data.append(contentsOf: bytes)
        let b64 = data.base64EncodedString()
    }
}
