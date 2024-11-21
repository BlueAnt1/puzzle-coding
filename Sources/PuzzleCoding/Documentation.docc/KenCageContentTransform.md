# Ken Cage Content Transform

Transform cage content into an integer.

## Overview

This is an <doc:OffsetTransform> that transforms KenKen or KenDoku cage content into an integer.
 
## Details

Size      | Operator offset | Max value 
:----:    | :-------------: | :-------: 
**3×3**   | 54              | 58            
**4×4**   | 384             | 388            
**5×5**   | 1023            | 1027            
**6×6**   | 1023            | 1027            
**7×7**   | 1023            | 1027
**8×8**   | 1023            | 1027              
**9×9**   | 1023            | 1027              
**16×16** | 1023            | 1027             
**25×25** | 1023            | 1027            

>Important: The multiplication operator forces us to deal with potentially very large values.
In order to manage encoding space requirements and taking into account that puzzles are for 
humans to solve, the maximum clue value is limited to 1023.

### Set up

```
size = number of cells in a puzzle row or column
maxClue = size³ × (size-1) × (size-2)
operatorOffset = min(maxClue, 1023)
operators: 1 = add, 2 = subtract, 3 = multiply, 4 = divide
maxValue = operatorOffset + 4
```

### Encode

```
if the cell is empty
    output = 0
else if the cell contains a clue
    output = clue
else if the cell contains an operator
    output = operator + operatorOffset
```

### Decode

```
if input > maxValue
    error
else if input > operatorOffset
    operator = input - operatorOffset
else if input > 0
    clue = input
else
    empty
```
