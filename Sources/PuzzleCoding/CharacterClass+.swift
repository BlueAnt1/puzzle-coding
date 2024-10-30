//
//  CharacterClass+.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/30/24.
//

import RegexBuilder

extension ClosedRange<Int> {
    var characters: CharacterClass {
        var characters = Set<Character>()
        for value in self where characters.count < PuzzleCoding.radix {
            characters.formUnion(String(value, radix: PuzzleCoding.radix))
        }
        return CharacterClass.anyOf(characters)
    }
}

//extension PuzzleType {
//    static var characters: CharacterClass {
//        CharacterClass.anyOf(allCases.map(\.rawValue))
//    }
//}

extension Size {
    static var characters: CharacterClass {
        CharacterClass.anyOf(allCases.map(\.houseCellCount).map { String($0, radix: PuzzleCoding.radix).first! })
    }
}
