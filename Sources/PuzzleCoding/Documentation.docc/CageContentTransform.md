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

Finally we convert the operators to numbers.

@Row {
    @Column {
        Operator | Value
        :------: | :---:
        \+       | 1
        −       | 2
        ×        | 3
        ∕        | 4
    }
    @Column {
        ![Fully transformed cage](CageFullyTransformed)
    }
}

