# Shapes

A shape is a group of puzzle cells.

## Overview

Shapes are used to describe irregular groups of cells such as a Jigsaw piece or a cage.

@Row {
    @Column {
        ![Jigsaw shape](JigsawShape)
    }
    @Column {
        ![Cage shape](CageShape)
    }
}

## How to describe a shape

In order to describe a shape:

- Iterate the puzzle cells starting at A1.
- If the cell is the first of a shape, assign it a number, otherwise use the number of the shape of which the cell is a member.
- Be sure to keep the numbers within the limits imposed by the data requirements.
- For some puzzle types, like those with cages, numbers are recycled when no adjacent cells have the same color. 

The shape numbering for the cage diagram shown on the right is: 

```
1 1 2 1 2 1
2 3 2 1 2 1
2 3 3 1 2 3
2 4 4 4 3 3
1 1 2 2 2 1
1 3 3 3 1 1
```
