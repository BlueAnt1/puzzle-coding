//
//  OffsetGridPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

struct OffsetGridPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, Grid)

    let size: Size

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let offsetCoding = OffsetGridCoding(size: size)
        let fieldCoding = FieldCoding(range: offsetCoding.range, radix: PuzzleCoding.radix)
        let arrayPattern = ArrayPattern(repeating: fieldCoding.pattern, count: size.gridCellCount)

        guard let match = try? arrayPattern.regex
            .prefixMatch(in: input[index ..< bounds.upperBound])
        else { return  nil }

        let numbers = match.output.1
        var grid = Grid(size: size)

        do {
            for (index, number) in zip(numbers.indices, numbers) {
                grid[index] = try offsetCoding.decode(number)
            }
        } catch { return nil }
        
        return (match.range.upperBound, (match.output.0, grid))
    }
}
