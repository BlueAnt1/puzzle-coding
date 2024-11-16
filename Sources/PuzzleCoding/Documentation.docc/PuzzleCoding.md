# ``PuzzleCoding``

Encode Sudoku and related puzzles as text.

## Overview

Share puzzles with others by converting them to text & back.

The encodings are:
- an interchange format.
- web friendly so they can appear in a URL.
- relatively easy to decode without this library.
- compatible with [SudokuWiki](https://sudokuwiki.org).

You can learn about the <doc:EncodingFormats> or keep reading for an overview of the library.

## Usage

### Decode a puzzle

1. Pass the encoded puzzle string to the ``PuzzleCoder/decode(_:)`` method of a puzzle coder.
2. Copy the decoded data into your puzzle model.

@Snippet(path: "PuzzleCoding/Snippets/UsageDecode")

### Encode a puzzle

1. For every cell in your model create a ``Cell`` and populate it with information about the puzzle.
2. Create a puzzle coder with the cells.
3. Call the ``PuzzleCoder/encode(using:)`` method of the coder to generate the encoded string.

@Snippet(path: "PuzzleCoding/Snippets/UsageEncode")

## Topics

### Essentials

- ``Cell``

### Puzzle Coders

Coders convert puzzles to text and back.

- ``JigsawSudoku``
- ``KenKen``
- ``KillerJigsaw``
- ``KillerSudoku``
- ``Str8ts``
- ``Sudoku``
- ``SudokuX``
- ``Windoku``
