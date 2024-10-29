# Offset Grid Algorithm

Code grid content using offsets.

## Overview

We need to encode the content of a cell in a limited amount of space.
This algorithm represents each type of content as a unique range of values.

Iterate over every cell in the grid and encode the cell's content into a field using offsets. Build the output by concatenating the fields.

Offsets vary based on the size of the grid.

```
size = number of cells in a grid row or column
solutionOffset = size
candidatesOffset = 2 * size
```

A field consists of 2 characters representing a base 36 value, padded with a leading zero if needed.

Learn how to <doc:PackCandidates>.

## Encode

```
for every cell in the grid
    if cell is empty
        field = 0
    else if cell contains clue
        field = clue
    else if cell contains solution
        field = solution + solutionOffset
    else 
        field = pack(candidates) + candidatesOffset
```

## Decode

```
maximum = pack(1...size) + candidatesOffset

for every pair of characters in the input
    value = convert the characters to a base 36 value

    if value > maximum
        // error
    else if value > candidatesOffset
        candidates = unpack(value - candidatesOffset)
    else if value > solutionOffset
        solution = value - solutionOffset
    else if value > 0
        clue = value
    else
        // empty
```
