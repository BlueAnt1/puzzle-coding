//
//  HeaderTests.swift
//  puzzle-coding
//
//  Created by Quintin May on 11/3/24.
//

import Testing
@testable import PuzzleCoding

struct HeaderTests {

    @Test(arguments: Size.allCases)
    func headerRoundTrips(size: Size) throws {
        let coder = Header(puzzleType: .sudoku, size: size, version: "B")
        let raw = coder.rawValue
        #expect(raw.count == 3)

        let match = try #require(try HeaderPattern(sizes: Size.allCases).regex.wholeMatch(in: raw))
        #expect(String(match.output.0) == raw)
    }
}
