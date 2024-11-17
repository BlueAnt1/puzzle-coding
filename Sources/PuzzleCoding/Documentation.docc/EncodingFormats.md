# Encoding Formats

Puzzle encoding format reference.

## Overview

The formats are an evolution of encodings that have been in use for years. Over that time new puzzles have been developed and requirements
for the data exchanged have evolved. The new encoding format is designed to be resilient to change in the future.

Every encoding starts with a header which is followed by the puzzle data.

## Header

The header's purpose is to describe what comes later. It contains the puzzle type, the size of the puzzle and the version of the encoding.
As new requirements for the transferred data evolve the version will change.

All numeric values are encoded as base 36 characters. The encodings are not case sensitive.

A sample header: `S9B`
- The first character is the puzzle type
- The second character is the puzzle size (base 36)
- The third character is the encoding version which is always a letter A...Z

@Row {
    @Column {
        ### Puzzle types

        Puzzle Type   | Code
        :----------   | :----:
        Jigsaw Sudoku |   J
        KenDoku       |   D
        KenKen        |   K
        Killer Jigsaw |   M
        Killer Sudoku |   L
        Sudoku        |   S
        SudokuX       |   X
        Str8ts        |   T
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

Every puzzle type has its own data requirements.

![Puzzle requirements table](PuzzleRequirements)

To read the table, find the row with the puzzle type in which you're interested. Then read across.

Green cells indicate the data that is required for the puzzle type and the range of permitted values. Many of the ranges are described as `1…size`. This means that the range is based on the size of the puzzle. For a 9×9 Sudoku the *Cell Content Candidates* must be a set of values in the range 1…9. For a 6×6 KenKen the *Cell Content Solution* must be a value in the range 1…6.

## Data types

There are three general types of data to encode.

- term Shapes: <doc:Shapes> describe groupings of cells; the cells of a Jigsaw piece or the outline of a cage for example.
- term Cage Content: <doc:Cages> contain additional clues about a group of cells such as the sum of their content.
- term Cell Content: Cell content is what we typically consider the data *in* a cell. It is the clue, solution or candidates (the *progress*) of the puzzle.

> Note: The `∅` column under Cage Content and Cell Content indicates that *empty* is a valid value. Emptiness is denoted by the value `0`.

## Version B coding

All puzzles are currently using Version B coding. Version B uses 3 types of transformations to produce encoded output.

- term Pack: [Transform a set of *candidates*](<doc:PackCandidates>) into a single value.
- term Offset: [Transform a set of *mutually exclusive* values](doc:OffsetTransform) into a single value. This is used for both cell and cage content. For example, a cell has multiple types of content: clue, solution or candidates that need to be described, but only one of these types of data is present at a time.
- term Shift: [Transform a group of values](<doc:ShiftTransform>) into a single value. This is the final transformation that combines all values into a single integer representation for the data describing a cell.

Some types of data go through multiple transformations as shown in the table. For example *Cell Content Candidates* are first packed and then offset. If we're coding a Jigsaw Sudoku the *Shapes Box* values are shifted along with the offset candidates to produce a new value.

Once all of the data for a cell has been transformed into a single value use <doc:FieldCoding> to output the value.

## Puzzles

Choose your puzzle type and encode each cell using the transforms
@TabNavigator {
    @Tab("Jigsaw Sudoku") {
        - <doc:ShiftTransform>
            - box number
            - <doc:CellContentTransform>
    }
    @Tab("KenDoku") {
        - <doc:ShiftTransform>
            - cage number
            - <doc:CageContentTransform>
            - <doc:CellContentTransform>
    }
    @Tab("KenKen") {
        - <doc:ShiftTransform>
            - cage number
            - <doc:CageContentTransform>
            - <doc:CellContentTransform>
    }
    @Tab("Killer Jigsaw") {
        - <doc:ShiftTransform>
            - box number
            - cage number
            - <doc:CageContentTransform>
            - <doc:CellContentTransform>
    }
    @Tab("Killer Sudoku") {
        - <doc:ShiftTransform>
            - cage number
            - <doc:CageContentTransform>
            - <doc:CellContentTransform>
    }
    @Tab("Str8ts") {
        - <doc:ShiftTransform>
            - box number
            - <doc:CellContentTransform>
    }
    @Tab("Sudoku+") {
        Sudoku, SudokuX and Windoku use the same encoding.
        
        - <doc:CellContentTransform>
    }
}
