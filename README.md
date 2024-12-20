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
for (index, cell) in zip(model.indices, puzzle) {
    if case .solution(let clue) = cell.clue {
        model[index].clue = clue
    } else switch cell.progress {
        case .guess(let guess):
            model[index].guess = guess
        case .candidates(let candidates):
            model[index].candidates = candidates
        }
    }
}
```
