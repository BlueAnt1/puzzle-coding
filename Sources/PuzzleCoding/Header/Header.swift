//
//  Header.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

struct Header {
    let puzzleType: PuzzleType
    let size: Size
    let version: Character

    var rawValue: String {
        """
        \(puzzleType.rawValue)\
        \(String(size.rawValue, radix: FieldCoding.radix))\
        \(version)
        """.uppercased()
    }
}

