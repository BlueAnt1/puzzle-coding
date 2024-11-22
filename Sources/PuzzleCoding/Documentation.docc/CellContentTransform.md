# Cell Content Transform

Transform cell content into an integer.

## Overview

A cell can contain nothing, a clue, solution or set of candidates, but only one of those at a time; the values are mutually exclusive. This allows us to reuse the same set of bits for the different value types. To distinguish the different value types we force each into its own range of values.

## Details

Size      | Solution offset | Candidates offset | Max value
:----:    | :-------------: | :---------------: | :---------:
**3×3**   |  3              | 6                 | 13
**4×4**   |  4              | 8                 | 23
**5×5**   |  5              | 10                | 41
**6×6**   |  6              | 12                | 75
**7×7**   |  7              | 14                | 141
**8×8**   |  8              | 16                | 271
**9×9**   |  9              | 18                | 529
**16×16** | 16              | 32                | 65,567
**25×25** | 25              | 50                | 33,554,481

### Set up

```
size = number of cells in a puzzle row or column
solutionOffset = size
candidatesOffset = 2 * size
maxPackedCandidatesValue = pack(1...size)
maxValue = maxPackedCandidatesValue + candidatesOffset
```

Learn how to <doc:PackCandidates>.

### Encode

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
