//
//  KillerJigsaw+.swift
//  PuzzleCoding
//
//  Created by Quintin May on 11/14/24.
//

@testable import PuzzleCoding

extension JigsawSudoku {
    static var andrewStuart1Example1: JigsawSudoku {
        let shapes = """
                    111222233
                    111222233
                    114452333
                    144455633
                    444555666
                    774556669
                    777856699
                    778888999
                    778888999
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)

        let content = parse("""
                4[3568][3568]7[1356]9[56]2[168]
                [3568][35678][35678][135]2[3456][456][356789][146789]
                [2356]9[1356][135][3567]8[4567][3567][1467]
                1[568]4[589][56789][256]3[56789][6789]
                7[3568][35689]4[35689]1[5689][5689]2
                [5689][45678]2[589][56789][456]1[56789]3
                [23589][234578][35789]6[35789][45][45789]1[789]
                [235689][235678][13589][13589]4[35][26789][6789][6789]
                [3689]1[389]2[389]7[689]45
                """)


        let cells = shapes.indices.map {
            Cell(region: shapes[$0],
                 content: content[$0])
        }

        return try! JigsawSudoku(cells: cells)
    }

    private static func parse(_ input: String) -> [Cell.Content?] {
        var output: [Cell.Content?] = []
        var input = input[...]
        var candidates = Set<Int>()
        var isCandidates = false

        while !input.isEmpty {
            let character = input.removeFirst()
            guard !character.isWhitespace else { continue }
            switch character {
            case "[" where !isCandidates:
                isCandidates = true
            case "1"..."9" where isCandidates:
                candidates.insert(character.wholeNumberValue!)
            case "]" where isCandidates:
                isCandidates = false
                output.append(.candidates(candidates))
                candidates = []
            case "1"..."9":
                output.append(.clue(character.wholeNumberValue!))
            default:
                return []
            }
        }
        return output
    }

    static var doubleMirror: JigsawSudoku {
//        let shapes = """
//                    111123333
//                    111222333
//                    142222253
//                    144666553
//                    444666555
//                    744666558
//                    749999958
//                    777999888
//                    777798888
//                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let shapes = """
                    111123333
                    111222333
                    132222213
                    133444113
                    333444111
                    133444112
                    135555512
                    111555222
                    111152222
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
        let content:[Cell.Content?] = """
                    000000000
                    060000070
                    009105200
                    070000004
                    308000506
                    500030020
                    003704600
                    020000030
                    000002000
                    """.filter { !$0.isWhitespace }.map(\.wholeNumberValue!)
            .map { $0 == 0 ? .candidates(Set(1...9)) : .clue($0) }

        let cells = shapes.indices.map {
            Cell(region: shapes[$0],
                 content: content[$0])
        }

        return try! JigsawSudoku(cells: cells)
    }
}
