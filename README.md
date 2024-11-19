# Puzzle Coding

The Puzzle Coding package is a library that enables the exchange of Sudoku and related puzzles by providing methods to convert the puzzles to text and back.

## Usage

Please see the [Puzzle Coding documentation](https://blueant1.github.io/puzzle-coding) for more information.

```swift
let input = "S9Bel0fbd01ep050eel9u…"
// decode the input
guard let puzzle = Sudoku(rawValue: input)
else { return }

// copy the decoded data into your model
for (index, content) in zip(model.indices, puzzle) {
    switch content {
    case nil:
        model[index].empty = true
    case .clue(let clue):
        model[index].clue = clue
    case .solution(let solution):
        model[index].solution = solution
    case .candidates(let candidates):
        model[index].candidates = candidates
    }
}
```
