# Puzzle Coding

The Puzzle Coding package is a library that enables the exchange of Sudoku and related puzzles by providing methods to convert the puzzles to text and back.

## Usage

Please see the [Puzzle Coding documentation](https://blueant1.github.io/puzzle-coding) for more information.

```swift
let input = "S9Bel0fbd01ep050eel9u…"
guard let (puzzle, version) = Sudoku.decode(from: input)
else { return }

for content in puzzle.grid {
    switch content {
    case nil:
        processEmptyCell()
    case .clue(let clue):
        process(clue: clue)
    case .solution(let solution):
        process(solution: solution)
    case .candidates(let candidates):
        process(candidates: candidates)
    }
}

let output = puzzle.encode(to: version)
assert(output == input)
```
