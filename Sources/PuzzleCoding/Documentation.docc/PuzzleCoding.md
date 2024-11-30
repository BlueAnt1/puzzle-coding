# ``PuzzleCoding``

@Metadata {
    @DisplayName("Puzzle Coding")
}

Encode Sudoku and related puzzles as text.

## Overview

Share puzzles with others by converting them to text & back.

The encodings are:
- web friendly so they can appear in a URL.
- relatively easy to decode without this library.
- compatible with [SudokuWiki.org](https://sudokuwiki.org) & [Str8ts.com](https://str8ts.com).

You can learn about the <doc:EncodingFormats> or keep reading for an overview of the library.

>Note: I'd like to thank Andrew Stuart of [Syndicated Puzzles](http://www.syndicatedpuzzles.com) for his input in the development of
these encodings. They are the evolution of encodings he's been using to transport puzzles on his websites for many years.

## Usage

### Decode a puzzle

1. Pass the encoded puzzle string to the ``Puzzle/init(rawValue:)`` initializer of a puzzle type.
2. Copy the decoded data into your puzzle model.

```swift
let input = "S9Bel0fbd01ep050eel9u…"
// decode the input
guard let puzzle = Sudoku(rawValue: input)
else { return }

// copy the decoded data into your model
for (index, cell) in zip(model.indices, puzzle) {
    switch cell.content {
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

### Encode a puzzle

1. For every cell in your model create a ``Cell`` and populate it with information about the puzzle.
2. Create a puzzle with the cells.
3. The ``Puzzle/rawValue`` property of the puzzle contains the encoded string.

```swift
var cells: [Cell] = []

// copy your model data into cells
for modelCell in model {
    let cell = Cell(content: modelCell.content)
    cells.append(cell)
}

if let puzzle = try? Sudoku(cells: cells) {
    // rawValue is the encoded puzzle
    let encoded = puzzle.rawValue
    print(encoded)
}
```

## Topics

### Essentials

- ``Cell``
- ``Puzzle``

### Puzzles

- ``JigsawSudoku``
- ``KenDoku``
- ``KenKen``
- ``KillerJigsaw``
- ``KillerSudoku``
- ``Str8ts``
- ``Str8tsB``
- ``Str8tsBX``
- ``Str8tsX``
- ``Sudoku``
- ``SudokuX``
- ``Windoku``

### Encoding

- <doc:EncodingFormats>
- <doc:PackCandidates>
- <doc:CellContentTransform>
- <doc:Str8tsCellContentTransform>
- <doc:CageContentTransform>
- <doc:ShiftTransform>
- <doc:FieldCoding>
- <doc:Shapes>
