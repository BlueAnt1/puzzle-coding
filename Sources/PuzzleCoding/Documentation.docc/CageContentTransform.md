# Cage Content Transform

Transform cage content into an integer.

## Overview

There are two aspects to describing cages. We have to describe both the <doc:Shapes> of the cages and the clues & operators.

## How to describe cage clues & operators

@Row {
    @Column {
        ![Cage](Cage)
    }
    @Column {
        Notice that there are more empty cells than cells with clues. We take advantage of the empty
        cells to more efficiently utilize space by separating the clue from the operator. 
    }
}
@Row {
    @Column {
        A cage clue, for example the 24 in A1 always appears in the first cell of the cage. 
        
        For KenDoku and KenKen the second cell of a cage (when there is more than one cell in the cage) contains the
        operator. 
        
        The second cell is the cell to the right of the clue if there is a cell to the right, else the cell below the clue,
        in the same cage.
    }
    @Column {
        ![Transformed cage](CageTransformed)
    }
}

@Row {
    @Column {
        ![Fully transformed cage](CageFullyTransformed)
    }
    @Column {
        Finally, convert the operators and empty cells to numbers.

        Content  | Value
        :------: | :---:
        *empty*  | 0
        \+       | 1
        −        | 2
        ×        | 3
        ∕        | 4
    }
}

## Limitations

The multiplication operator forces us to deal with potentially very large clues. The largest clue value for a puzzle
is: size³ × (size−1) × (size−2). In order to manage space in the encoding, the maximum clue
value is limited to 2047.

Size    | Max Clue
:--:    | :------:
3×3     | 54
4×4     | 384
5×5     | 1500
6×6     | 2047
7×7     | 2047
8×8     | 2047
9×9     | 2047
16×16   | 2047
25×25   | 2047
