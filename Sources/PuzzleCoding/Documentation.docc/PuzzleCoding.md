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
- compatible with [SudokuWiki](https://sudokuwiki.org).

You can learn about the <doc:EncodingFormats> or keep reading for an overview of the library.

>Note: I'd like to thank Andrew Stuart of [Syndicated Puzzles](http://www.syndicatedpuzzles.com) for his input in the development of
these encodings. They are the evolution of encodings he's been using to transport puzzles on his websites for many years.

## Usage

### Decode a puzzle

1. Pass the encoded puzzle string to the ``Puzzle/init(rawValue:)`` initializer of a puzzle type.
2. Copy the decoded data into your puzzle model.

@Snippet(path: "PuzzleCoding/Snippets/UsageDecode")

### Encode a puzzle

1. For every cell in your model create a ``Cell`` and populate it with information about the puzzle.
2. Create a puzzle with the cells.
3. The ``Puzzle/rawValue`` property of the puzzle contains the encoded string.

@Snippet(path: "PuzzleCoding/Snippets/UsageEncode")

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
- ``Sudoku``
- ``SudokuX``
- ``Windoku``

### Encoding

- <doc:EncodingFormats>
- <doc:PackCandidates>
- <doc:OffsetTransform>
- <doc:CellContentTransform>
- <doc:KenCageContentTransform>
- <doc:KillerCageContentTransform>
- <doc:ShiftTransform>
- <doc:FieldCoding>
- <doc:Shapes>
- <doc:Cages>
