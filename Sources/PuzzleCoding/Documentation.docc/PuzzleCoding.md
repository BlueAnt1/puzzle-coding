# ``PuzzleCoding``

Encode Sudoku and related puzzles as text.

## Overview

Share your puzzles with others by converting them to text & back.

The encodings are:
- an interchange format that's relatively easy to decode without this library
- web friendly so they can appear in a URL
- compatible with [SudokuWiki](https://sudokuwiki.org)

You can learn about the <doc:EncodingFormats> or keep reading to use the library.

## Usage

### Decode a puzzle

1. Pass the encoded puzzle string to the ``PuzzleCoder/decode(_:)`` method of a puzzle coder.
2. Copy the decoded data into your puzzle model.

@Snippet(path: "PuzzleCoding/Snippets/UsageDecode")

```swift
let input = "S9Bel0fbd01ep050eel9u…"
// decode the input
guard let (puzzle, version) = Sudoku.decode(input)
else { return }

// copy the decoded data into your model
for index in grid.indices {
    switch grid[index] {
    case nil:
        // set model[index] to empty
    case .clue(let clue): 
        // set model[index] to the clue value
    case .solution(let solution): 
        // set model[index] to the solution value
    case .candidates(let candidates):
        // set model[index] to the candidates
    }
}
```

### Encode a puzzle

1. Create a ``Grid`` and populate it with the clues, solutions & candidates of your model.
2. Create a puzzle coder with the grid and any other model data relevant to the puzzle type.
3. Call the ``PuzzleCoder/encode(using:)`` method of the coder to generate the encoded string.

```swift
var grid = Grid()

// copy your model data into the grid
for index in grid.indices {
    grid[index] = convert model[index] cell data to CellContent
}

let coder = Sudoku(grid: grid)
// encode the puzzle
let encoded = coder.encode()
```

## Topics

### Essentials

- ``Grid``

### Puzzle Coders

Coders convert puzzles to text and back.

- ``Jigsaw``
- ``KillerJigsaw``
- ``KillerSudoku``
- ``Str8ts``
- ``Sudoku``
- ``SudokuX``
- ``Windoku``
