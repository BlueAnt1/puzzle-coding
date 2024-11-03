# Encoding Formats

Understand puzzle encoding formats.

## Overview

The formats are based on the learnings of years of encoding puzzles. Over that time new puzzles have been developed and new requirements
for the data exchanged have evolved. The hope is that the structure of the encodings is resilient to changes in requirements going forward.

Every encoding starts with a header which is followed by the puzzle data.

## Header

The header's purpose is to describe what comes later. It contains the puzzle type, the size of the puzzle and the version of the encoding.
As new requirements for the transferred data evolve the version number will change.

All numeric values are encoded as base 32 characters and the encodings are not case sensitive.

A sample header: `S9B`
- The first character represents the puzzle type
- The second character is the puzzle size (base 32)
- The third character is the encoding version which is always a letter A...Z

### Puzzle types

Puzzle Type   | Code
:----------   | :----:
Jigsaw        |   J
Str8ts        |   T
KenKen        |   K
KenDoku       |   D
Killer Sudoku |   L
Killer Jigsaw |   M
Sudoku        |   S
SudokuX       |   X
Windoku       |   W

### Puzzle sizes

Size  | Code
:---  | :----:
6×6   |   6
8×8   |   8
9×9   |   9
16×16 |   G
25×25 |   P

### Encoding version

The current encoding version is `B` which indicates <doc:OffsetGridCoding>.

## Puzzle data

Every puzzle type has its own data requirements. We'll start with the simplest & build up from there.

### Sudoku, SudokuX & Windoku

These puzzle types encode their grid data using the encoding version specified in the header.

