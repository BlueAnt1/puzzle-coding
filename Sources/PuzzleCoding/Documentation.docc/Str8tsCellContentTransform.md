# Str8ts Cell Content Transform

Transform cell content into an integer.

## Overview

A cell can contain nothing, a clue, black nothing, a black clue, a solution or set of candidates, but only one of those at a time; the values are mutually exclusive. This allows us to reuse the same set of bits for the different value types. To distinguish the different value types we force each into its own range of values.

## Details

Size      | Black empty | Black clue offset | Solution offset | Candidates offset | Max value
:----:    | :---------: | :---------------: | :-------------: | :---------------: | :---------:
**3×3**   | 4           | 4                 | 7               | 10                | 17
**4×4**   | 5           | 5                 | 9               | 13                | 28
**5×5**   | 6           | 6                 | 11              | 16                | 47
**6×6**   | 7           | 7                 | 13              | 19                | 82
**7×7**   | 8           | 8                 | 15              | 22                | 149
**8×8**   | 9           | 9                 | 17              | 25                | 280
**9×9**   | 10          | 10                | 19              | 28                | 539
**16×16** | 17          | 17                | 33              | 49                | 65,584
**25×25** | 26          | 26                | 51              | 76                | 33,554,507

### Set up

```
size = number of cells in a puzzle row or column
blackEmpty = size + 1
blackClueOffset = blackEmpty
solutionOffset = size + blackClueOffset
candidatesOffset = 2 * size + blackClueOffset
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
else if the cell is black and empty
    output = blackEmpty
else if the cell contains a black clue
    output = black clue + blackClueOffset
else if the cell contains a solution
    output = solution + solutionOffset
else
    output = pack(candidates) + candidatesOffset
```

### Decode

```
if input > maxValue
    error
else if input > candidatesOffset
    candidates = unpack(input - candidatesOffset)
else if input > solutionOffset
    solution = input - solutionOffset
else if input > blackClueOffset
    black clue = input - blackClueOffset
else if input == blackEmpty
    black empty
else if input > 0
    clue = input
else
    empty
```
