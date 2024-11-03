//
//  SudokuShiftCoder.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/22/24.
//

extension Sudoku {
    struct Shift: VersionCoder {
        fileprivate static var radix: Int { 32 }
        fileprivate static var fieldWidth: Int { 2 }

        static func encode(_ puzzle: Sudoku) -> String {
            var result = ""
            for content in puzzle.grid {
                switch content {
                case nil:
                    encode(0)
                case .clue(let value), .solution(let value):
                    let bits = 1 << (value - 1)
                    let isClue = if case .clue = content  { true } else { false }
                    let encoded = bits << 1 | (isClue ? 1 : 0)
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

        static func decode(_ input: String) -> Sudoku? {
            guard input.count == 162,
                  let match = try? ShiftedGridPattern().regex.wholeMatch(in: input)
            else { return nil }

            return Sudoku(grid: match.output)
        }
    }
}

private struct ShiftedGridPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = Grid

    var radix: Int { Sudoku.Shift.radix }
    var fieldWidth: Int { Sudoku.Shift.fieldWidth }

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        var grid = Grid()

        var encoded = input[index ..< bounds.upperBound]

        for cell in grid.indices {
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
                grid[cell] = isClue ? .clue(value) : .solution(value)
            } else {
                // candidates
                grid[cell] = .candidates(value.oneBits)
            }
        }

        return (encoded.startIndex, grid)
    }
}
