//
//  Coder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/28/24.
//

protocol Coder<Puzzle> {
    associatedtype Puzzle
    static func encode(_ puzzle: Puzzle) -> String
    static func decode(from input: String) -> Puzzle?
}
