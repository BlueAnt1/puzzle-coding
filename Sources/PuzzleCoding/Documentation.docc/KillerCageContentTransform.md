# Killer Cage Content Transform

Transform cage content into an integer.

## Overview

This is an <doc:OffsetTransform> that transforms Killer Jigsaw or Killer Sudoku cage content into an integer.

>Note: This is a degenerate case of the offset transform since there's only one data type to represent.
 
## Details

Size      | Max value 
:----:    | :-------: 
**6×6**   | 21            
**8×8**   | 36              
**9×9**   | 45              
**16×16** | 136             
**25×25** | 325            

### Set up

```
size = number of cells in a puzzle row or column
maxValue = 1 + 2 + 3 + ... + size
```

### Encode

```
if the cell is empty
    output = 0
else if the cell contains a clue
    output = clue
```

### Decode

```
if input > maxValue
    // error
else if input > 0
    clue = input
else
    // empty
```
