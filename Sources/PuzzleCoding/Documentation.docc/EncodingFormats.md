# Encoding Formats

Puzzle encoding format reference.

## Overview

The formats are an evolution of encodings that have been in use for years. Over that time new puzzles have been developed and requirements
for the data exchanged have evolved. The new encoding format is designed to be resilient to change in the future.

Every encoding starts with a header which is followed by the puzzle data.

## Header

The header's purpose is to describe what comes later. It contains the puzzle type, the size of the puzzle and the version of the encoding.
As new requirements for the transferred data evolve the version will change.

All numeric values are encoded as base 32 characters. The encodings are not case sensitive.

A sample header: `S9B`
- The first character is the puzzle type
- The second character is the puzzle size (base 32)
- The third character is the encoding version which is always a letter A...Z

@Row {
    @Column {
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
    }
    
    @Column {
        ### Puzzle sizes

        Size  | Code
        :---  | :----:
        6×6   |   6
        8×8   |   8
        9×9   |   9
        16×16 |   G
        25×25 |   P 
    }
}

## Puzzle data

Every puzzle type has its own data requirements. We'll start with the simplest & build up from there.

### Sudoku, SudokuX & Windoku

@TabNavigator {
    @Tab("Version B") {
        - Transform the grid using <doc:CellContentTransform>.
        - Encode the transformed grid using <doc:FieldCoding>.
    }
}

### Str8ts

@TabNavigator {
    @Tab("Version B") {
        - Encode colorShapes using <doc:FieldCoding>.
        - Transform the grid using <doc:CellContentTransform>.
        - Encode the transformed grid using <doc:FieldCoding>.
    }
    @Tab("Experimental") {
        For every cell in the grid:
        - <doc:ShiftTransform>
            - colorShape
            - Transform cell content using <doc:CellContentTransform>.
        - Encode the transform using <doc:FieldCoding>
    }
}

### Jigsaw

@TabNavigator {
    @Tab("Version B") {
        - Encode boxShapes using <doc:FieldCoding>.
        - Transform the grid using <doc:CellContentTransform>.
        - Encode the transformed grid using <doc:FieldCoding>.
    }
}

### Killer Sudoku

@TabNavigator {
    @Tab("Version B") {
        - Transform cage clues & cage shapes using <doc:ShiftTransform>.
        - Encode the transform using <doc:FieldCoding>.
        - Transform the grid using <doc:CellContentTransform>.
        - Encode the transformed grid using <doc:FieldCoding>.
    }
}

### Killer Jigsaw

@TabNavigator {
    @Tab("Version B") {
        - Transform cage clues, cage shapes & box shapes using <doc:ShiftTransform>.
        - Encode the transform using <doc:FieldCoding>.
        - Transform the grid using <doc:CellContentTransform>.
        - Encode the transformed grid using <doc:FieldCoding>.
    }
    @Tab("Experimental") {
        For every cell in the grid:
        - <doc:ShiftTransform>
            - cageClues
            - cageShapes
            - boxShapes
            - Transform cell content using <doc:CellContentTransform>.
        - Encode the transform using <doc:FieldCoding>.
    }
}
