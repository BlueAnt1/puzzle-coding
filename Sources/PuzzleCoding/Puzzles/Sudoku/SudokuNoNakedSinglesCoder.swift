//
//  SudokuNoNakedSinglesCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct NoNakedSingles: Coder {
        fileprivate static var radix: Int { 32 }
        fileprivate static var fieldWidth: Int { 2 }
        fileprivate static var size: Size { .grid9x9 }

        static func encode(_ puzzle: Sudoku) -> String {
            var result = ""
            for cell in puzzle {
                switch cell.content {
                case nil:
                    encode(0)
                case .clue(let clue):
                    let bits = 1 << (clue - 1)
                    let encoded = bits << 1 | 1
                    encode(encoded)
                case .solution(let solution):
                    let bits = 1 << (solution - 1)
                    let encoded = bits << 1
                    encode(encoded)
                case .candidates(let candidates):
                    let encoded = candidates.bitValue << 1
                    encode(encoded)
                }
            }
            return result

            func encode(_ value: Int) {
                result.append(contentsOf: (String(repeating: "0", count: Self.fieldWidth) + String(value, radix: Self.radix)).suffix(Self.fieldWidth))
            }
        }

        static func decode(_ input: String, type: PuzzleType) -> Sudoku? {
            guard input.count == Self.size.gridCellCount * Self.fieldWidth,
                  let match = try? NoNakedSinglesPattern().regex.wholeMatch(in: input)
            else { return nil }

            return try? Sudoku(cells: match.output.map { Cell(content: $0) }, version: .noNakedSingles, type: type)
        }
    }
}

private struct NoNakedSinglesPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = [CellContent?]

    var radix: Int { Sudoku.NoNakedSingles.radix }
    var fieldWidth: Int { Sudoku.NoNakedSingles.fieldWidth }
    var size: Size { Sudoku.NoNakedSingles.size }

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        var content: [CellContent?] = Array(repeating: nil, count: size.gridCellCount)
        var encoded = input[index ..< bounds.upperBound]

        for cell in content.indices {
            let field = encoded.prefix(fieldWidth)
            encoded = encoded.dropFirst(fieldWidth)
            guard field.count == fieldWidth,
                  var value = Int(field, radix: radix)
            else { return nil }

            guard value != 0 else { continue }

            let isClue = value & 0b1 == 1
            value &>>= 1
            if value.nonzeroBitCount == 1 {
                // clue & solution
                let value = value.trailingZeroBitCount + 1
                content[cell] = isClue ? .clue(value) : .solution(value)
            } else {
                // candidates
                content[cell] = .candidates(value.oneBits)
            }
        }

        return (encoded.startIndex, content)
    }
}
