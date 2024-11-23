# Cage Content Transform

Transform cage content into an integer.

## Overview

@Row {
    @Column {
        ![Cage](Cage)
    }
    @Column {
        ![Transformed cage](CageTransformed)
    }
}

The clues and operators in the left grid are transformed into the right grid.

## How to describe cages

To describe cages we need to describe the <doc:Shapes> of the cages as well as the clues & operators.

Notice that there are a lot more empty cells than cells with clues. In order to more efficiently utilize space we separate
the clue from the operator. 

A cage clue, for example the 24 in A1 always appears in the first cell of the cage. 
For KenDoku and KenKen the second cell of a cage (when there is more than one cell in the cage) contains the
operator. The second cell is the cell to the right of the clue if there is a cell to the right, else the cell below the clue.

Finally, convert the operators and empty cells to numbers.

@Row {
    @Column {
        Content  | Value
        :------: | :---:
        *empty*  | 0
        \+       | 1
        −        | 2
        ×        | 3
        ∕        | 4
    }
    @Column {
        ![Fully transformed cage](CageFullyTransformed)
    }
}

## Limitations

The multiplication operator forces us to deal with potentially very large clues. The largest clue value for a puzzle
of a particular size is: size³ × (size−1) × (size−2). In order to manage space in the encoding, the maximum clue
we represent is capped at 2047.

Size | Max Clue
:--: | :------:
3    | 54
4    | 384
5    | 1500
6    | 2047
7    | 2047
8    | 2047
9    | 2047
16   | 2047
25   | 2047
