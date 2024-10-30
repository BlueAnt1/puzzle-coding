//
//  HeaderCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

struct HeaderCoder {
    let puzzleType: PuzzleType
    let size: Size
    let version: Character

    var rawValue: String {
        """
        \(puzzleType.rawValue)\
        \(String(size.houseCellCount, radix: PuzzleCoding.radix))\
        \(version)
        """.uppercased()
    }
}

