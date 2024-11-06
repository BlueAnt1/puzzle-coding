//
//  Zipper.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/6/24.
//

struct Zipper: RandomAccessCollection {
    var collections: [[Int]]

    init(_ collections: [[Int]]) {
        precondition(collections.allSatisfy { $0.count == collections[0].count })
        self.collections = collections
    }

    var startIndex: Int { collections[0].startIndex }
    var endIndex: Int { collections[0].endIndex }
    subscript(_ position: Int) -> [Int] {
        get { collections.map { $0[position] }}
        set {
            precondition(newValue.count == collections.count)
            for index in indices {
                collections[index][position] = newValue[index]
            }
        }
    }
}
