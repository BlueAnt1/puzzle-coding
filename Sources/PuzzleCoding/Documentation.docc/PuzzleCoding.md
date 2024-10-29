# ``PuzzleCoding``

Encode Sudoku and related puzzles as text.

## Overview

We sometimes wish to share puzzles with others. PuzzleCoding makes converting a puzzle to text & back easy. The textual codings
generated are web friendly so they can appear in a URL.

PuzzleCoding does not attempt to create the smallest possible encodings, but rather creates encodings that others who are not
using this library can easily decode.

## Usage

```swift
let input = "S33el0fbd01ep050eel9u…"
guard let (puzzle, version) = Sudoku.decode(from: input)
else { return }

for content in puzzle.grid {
    switch content {
    case nil:   // empty
    case .clue(let clue):
    case .solution(let solution):
    case .candidates(let candidates): 
    }
}

let output = puzzle.encode(to: version)
assert(output == input)
```

## Topics

### Essentials

- ``Grid``

### Puzzle Coders

Coders convert puzzles to text and back. Every puzzle type has its own coder.

- ``Sudoku``
- ``Jigsaw``
- ``Str8ts``
- ``Killer``
