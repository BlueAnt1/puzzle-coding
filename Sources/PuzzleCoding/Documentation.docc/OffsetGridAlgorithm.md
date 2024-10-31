# Offset Grid Algorithm

Code grid content using offsets.

## Overview

We need to encode the content of a cell in a limited amount of space.
This algorithm represents each type of content as a unique range of values.

Iterate over every cell in the grid and encode the cell's content into a field using offsets. Build the output by concatenating the fields.

## Set up

Offsets vary based on the size of the grid.

```
size = number of cells in a grid row or column
solutionOffset = size
candidatesOffset = 2 * size
```

A field consists of a fixed number of characters representing a base 32 value, padded with leading zeroes if needed.
The field width varies based on the size of the grid and can range from 2 to 6 characters. For sizes 6, 8 and 9 the field width
is 2, size 16 has a field width of 4, and size 25 has a field width of 6.

```
maxPackedCandidatesValue = pack(1...size)
maxPackedCellValue = maxPackedCandidatesValue + candidatesOffset
maxEncodedCellValue = convert maxPackedCellValue to a base 32 string
fieldWidth = number of characters in maxEncodedCellValue
```

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
for every fieldWidth number of characters in the input
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
