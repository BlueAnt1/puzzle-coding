# Ken Cage Content Transform

Transform cage content into an integer.

## Overview

This is an <doc:OffsetTransform> that transforms KenKen or KenDoku cage content into an integer.
 
## Details

Size      | Operator offset | Max value 
:----:    | :-------------: | :-------: 
**6×6**   | 720             | 724            
**8×8**   | 1023            | 1027              
**9×9**   | 1023            | 1027              
**16×16** | 1023            | 1027             
**25×25** | 1023            | 1027            

### Set up

```
size = number of cells in a puzzle row or column
operatorOffset = min(1023, size!)   // "!" is the factorial operator
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
    // error
else if input > operatorOffset
    operator = input - operatorOffset
else if input > 0
    clue = input
else
    // empty
```
