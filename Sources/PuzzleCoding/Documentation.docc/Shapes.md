# Shapes

A shape is a group of puzzle cells.

## Overview

Shapes are used to describe groups of cells such as Jigsaw pieces or cages.

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
