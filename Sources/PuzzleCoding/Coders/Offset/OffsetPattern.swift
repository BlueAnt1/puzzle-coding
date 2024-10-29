//
//  OffsetPattern.swift
//  puzzle-coding
//
//  Created by Quintin May on 10/21/24.
//

struct OffsetPattern: CustomConsumingRegexComponent {
    typealias RegexOutput = (Substring, Grid)

    let boxShape: BoxShape

    func consuming(_ input: String,
                   startingAt index: String.Index,
                   in bounds: Range<String.Index>) -> (upperBound: String.Index, output: Self.RegexOutput)?
    {
        let size = boxShape.size
        let offsetCoding = OffsetCoding(size: size)
        let fieldCoding = FieldCoding(range: offsetCoding.range, radix: PuzzleCoding.radix)

        guard let match = try? fieldCoding.arrayPattern(count: size.gridCellCount).regex
            .prefixMatch(in: input[index ..< bounds.upperBound])
        else { return  nil }

        let numbers = match.output.1
        var grid = Grid(boxShape: boxShape)

        do {
            for (index, number) in zip(numbers.indices, numbers) {
                grid[index] = try offsetCoding.decode(number)
            }
        } catch { return nil }
        
        return (match.range.upperBound, (match.output.0, grid))
    }
}
