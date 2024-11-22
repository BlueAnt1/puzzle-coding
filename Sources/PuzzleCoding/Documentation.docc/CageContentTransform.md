# Cage Content Transform

Transform cage content into an integer.

## Overview

![Cage shape](CageShape)

The cages in the image are outlined and colored.

## How to describe cages

To describe cages we need to describe the <doc:Shapes> of the cages as well as the clues & operators.

Notice that there are a lot more empty cells than cells with clues. In order to more efficiently utilize space we separate
the clue from the operator. A cage clue, for example the 24 in A1 always appears in the first cell of the cage. 

For KenDoku and KenKen the second cell of a cage (when there is more than one cell in the cage) contains the
operator. The second cell is the cell to the right of the clue if there is a cell to the right, else the cell below the clue.
Cells with no clue or operator are empty.

The clues & operators in the above image are described as:

```
24  × 20 15 48  8
12 10  ×  ×  ×  +
 ×  +  0  0  0 30
 0  6  ×  0  0  ×
12  + 18  ×  0  7
 0 72  ×  0  0  +
```
