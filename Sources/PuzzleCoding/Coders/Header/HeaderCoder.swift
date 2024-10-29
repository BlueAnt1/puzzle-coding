//
//  HeaderCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

import RegexBuilder

struct HeaderCoder {
    let version: Character
    let boxShape: BoxShape

    var rawValue: String {
        "\(version)\(boxShape.rows)\(boxShape.columns)"
    }
}

