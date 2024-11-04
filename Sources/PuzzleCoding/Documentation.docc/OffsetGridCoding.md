# Offset Grid Coding

Code grid content using offsets.

## Overview

We need to encode the content of a puzzle cell in a limited amount of space.
This algorithm represents each type of content as a unique range of values.

## Details

### Set up

```
size = number of cells in a grid row or column
solutionOffset = size
candidatesOffset = 2 * size
maxPackedCandidatesValue = pack(1...size)
maxValue = maxPackedCandidatesValue + candidatesOffset
```

Learn how to <doc:PackCandidates>.

### Encode

Use <doc:FieldCoding> with `maxValue` to write the output.

```
if the cell is empty
    output = 0
else if the cell contains a clue
    output = clue
else if the cell contains a solution
    output = solution + solutionOffset
else
    output = pack(candidates) + candidatesOffset
```

### Decode

Use <doc:FieldCoding> with `maxValue` to read the input.

```
if input > maxValue
    // error
else if input > candidatesOffset
    candidates = unpack(input - candidatesOffset)
else if input > solutionOffset
    solution = input - solutionOffset
else if input > 0
    clue = input
else
    // empty
```
