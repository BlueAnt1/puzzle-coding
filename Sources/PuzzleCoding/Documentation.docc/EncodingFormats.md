# Encoding Formats

Puzzle encoding format reference.

## Overview

The formats are an evolution of encodings that have been in use for years. Over that time new puzzles have been developed and requirements
for the data exchanged have evolved. The new encoding format is designed to be resilient to change in the future.

All numeric values are encoded as base 36 characters. The encodings are not case sensitive.

Every encoding starts with a header. The header is followed by the puzzle data.

## Header

The header's purpose is to describe what comes later. It contains the puzzle type, the size of the puzzle and the version of the encoding.
As new requirements for the transferred data evolve the version will change.

A sample header: `S9B`
- The first character is the puzzle type.
- The second character is the puzzle size (base 36).
- The third character is the encoding version, a letter A…Z.

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
        Str8ts        |   T
        Sudoku        |   S
        SudokuX       |   X
        Windoku       |   W       
    }
    
    @Column {
        ### Puzzle sizes

        Size  | Code
        :--:  | :----:
        3×3   |   3
        4×4   |   4
        5×5   |   5
        6×6   |   6
        7×7   |   7
        8×8   |   8
        9×9   |   9
        16×16 |   G
        25×25 |   P 
    }
}

## Puzzle data

Every puzzle type has its own data requirements.

![Puzzle requirements table](PuzzleRequirements)
*<sup>†</sup> [maxClue](<doc:CageContentTransform#Limitations>)*

To read the table, find the row with the puzzle type in which you're interested. Then read across.

Green cells indicate the data that is required for the puzzle type and the range of permitted values. Many of the ranges are described as *1…size*. This means that the range is based on the size of the puzzle. For a 9×9 Sudoku the range is 1…9. For a 6×6 KenKen the range is 1…6.

## Data types

There are three general types of data to encode.

- term Shapes: <doc:Shapes> describe groupings of cells. The cells of a Jigsaw piece or a cage are examples.
- term Cage Content: Cages contain clues about a group of cells such as the sum of their content.
- term Cell Content: Cell content is what we typically consider the data *in* a cell. It is the clue, solution or candidates (the *progress*) of the puzzle.

> Important: The `∅` column under Cage Content and Cell Content indicates that *empty* is a valid value. Emptiness is denoted by the value `0`.

## Base encoding

All current puzzle encoding versions build on this base encoding.

This encoding transforms all of the information about each cell of a puzzle into an integer and appends
that value to the encoding being constructed. 

The base encoding uses 4 transformations to produce encoded output.

- term Pack: [Transform a set of candidates](<doc:PackCandidates>) into a single value.
- term Cell Content: [Transform cell content](<doc:CellContentTransform>) into a single value.
- term Cage Content: [Transform cage content](<doc:CageContentTransform>) into a single value.
- term Shift: [Transform a group of values](<doc:ShiftTransform>) into a single value. This is the final transformation that combines all values into a single integer representation for the data describing a cell.

Some types of data go through multiple transformations as shown in the table. For example *Cell Content Candidates* are first packed and then transformed with the cell content transform. If we're encoding a Jigsaw Sudoku the *Shapes Group* values are shifted along with the transformed candidates to produce a new value.

Once all of the data for a cell has been transformed into a single value use <doc:FieldCoding> to output the value.

## Puzzles

Choose your puzzle type and encode each cell using the transforms.

@TabNavigator {
    @Tab("Jigsaw Sudoku") {
        #### Version B
        @Row {
            @Column {
                - <doc:ShiftTransform>                
                    1. box number ([shape](<doc:Shapes>))
                    2. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("9×9") {
                        `11 1122 2222 2222`
                        
                        14 bits in a 3 character field
                    }
                }
            }
        }
    }
    @Tab("KenKen+") {
        #### Version C
        @Row {
            @Column {
                - <doc:ShiftTransform>
                    1. cage number ([shape](<doc:Shapes>))
                    2. <doc:CageContentTransform>
                    3. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("3×3") {
                        `1 1122 2222 3333`
                        
                        13 bits in a 3 character field
                    }
                    @Tab("4×4") {
                        `1 1122 2222 2223 3333`
                        
                        17 bits in a 4 character field
                    }
                    @Tab("6×6") {
                        `1 1122 2222 2222 2333 3333`
                        
                        21 bits in a 4 character field
                    }
                }
            }
        }
        
        KenDoku uses the same encoding.
    }
    @Tab("Killer Jigsaw") {
        #### Version B
        @Row {
            @Column {
                - <doc:ShiftTransform>
                    1. box number ([shape](<doc:Shapes>))
                    2. cage number ([shape](<doc:Shapes>))
                    3. <doc:CageContentTransform>
                    4. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("9×9") {
                        `111 1222 3333 3344 4444 4444`
                        
                        23 bits in a 5 character field
                    }
                }
            }
        }
    }
    @Tab("Killer Sudoku") {
        #### Version B
        @Row {
            @Column {
                - <doc:ShiftTransform>
                    1. cage number ([shape](<doc:Shapes>))
                    2. <doc:CageContentTransform>
                    3. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("9×9") {
                        `111 2222 2233 3333 3333`
                        
                        19 bits in a 4 character field
                    }
                }
            }
        }
    }
    @Tab("Str8ts") {
        #### Version B
        @Row {
            @Column {
                - <doc:ShiftTransform>
                    1. box number ([shape](<doc:Shapes>))
                    2. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("9×9") {
                        `122 2222 2222`
                        
                        11 bits in a 3 character field
                    }
                }
            }
        }
    }
    @Tab("Sudoku+") {
        #### Version B
        @Row {
            @Column {
                1. <doc:CellContentTransform>
            }
            @Column {
                @TabNavigator {
                    @Tab("9×9") {
                        `11 1111 1111`
                        
                        10 bits in a 2 character field
                    }
                }
            }
        }
        
        SudokuX and Windoku use the same encoding.        
    }
}
