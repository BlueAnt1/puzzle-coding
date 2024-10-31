# Offset Grid Algorithm

Code grid content using offsets.

## Overview

We need to encode the content of a cell in a limited amount of space.
This algorithm represents each type of content as a unique range of values.

Iterate over every cell in the grid and encode the cell's content into a field using offsets. Build the output by concatenating the fields.

## Set up

This is a cheat sheet for the set up. The values vary based on the grid size. The last section in this article explains how these values are derived.

grid size | solutionOffset | candidatesOffset | fieldWidth | maxPackedCellValue
:-------: | :------------: | :--------------: | :--------: | :----------------:
**6**     |        6       |        12        |      2     |      75
**8**     |        8       |        16        |      2     |      271
**9**     |        9       |        18        |      2     |      529
**16**    |        16      |        32        |      4     |      65,567
**25**    |        25      |        50        |      6     |      33,554,481

## Encode

```
output = ""
for each cell in the grid
    if cell is empty
        value = 0
    else if cell contains clue
        value = clue
    else if cell contains solution
        value = solution + solutionOffset
    else 
        value = pack(candidates) + candidatesOffset

    string = convert value to base 32
    field = pad string to `fieldWidth` with leading zeroes
    append field to output
```

Learn how to <doc:PackCandidates>.

## Decode

```
for each fieldWidth group of characters in the input
    value = convert the characters from base 32

    if value > maxPackedCellValue
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

## Set up details

Offsets & field width vary based on the size of the grid.

```
size = number of cells in a grid row or column
solutionOffset = size
candidatesOffset = 2 * size

maxPackedCandidatesValue = pack(1...size)
maxPackedCellValue = maxPackedCandidatesValue + candidatesOffset
maxEncodedCellValue = convert maxPackedCellValue to a base 32 string
fieldWidth = number of characters in maxEncodedCellValue
```
