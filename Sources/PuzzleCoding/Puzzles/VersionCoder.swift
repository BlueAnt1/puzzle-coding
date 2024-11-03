//
//  VersionCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

protocol VersionCoder<Puzzle> {
    associatedtype Puzzle
    static func encode(_ puzzle: Puzzle) -> String
    static func decode(_ input: String) -> Puzzle?
}
