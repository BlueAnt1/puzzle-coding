# Offset Transform

Transform mutually exclusive values into an integer.

## Overview

This transform allows us to store multiple types of data using the same set of bits since only one of the types of data is ever present at a time. We represent the different data types using different ranges of values.

>Note: Offset transform is not used directly, rather it is a transform style that is implemented by transforms tuned to the data requirements.

The offset transform is implemented by <doc:CellContentTransform>, <doc:KenCageContentTransform> and <doc:KillerCageContentTransform>.

## Details

The concept is that we force the values we need to represent into distinct value ranges.

### Example

We need to represent 3 distinct value types: appetizer, entree and dessert. We have 10 appetizers, 4 entrées and 7 desserts to represent. A person may select at most one of the menu items.

To represent these values we use offsets. Let's represent appetizers with the values `1…10`.

We'll then define the entrée offset as the maximum appetizer value: 10.
The range of entrées is `(entrée offset + 1)…(entrée offset + 4)` or `11…14`.

The dessert offset is the maximum entrée value: 14. The dessert range is `(dessert offset + 1)…(dessert Offset + 7)` or `15…21`. 

No menu selection is represented as 0. The maximum value we represent is 21.

### Encode

```
if there is no menu selection
    output = 0
else if the selection is an appetizer
    output = appetizer value
else if the selection is an entrée
    output = entrée value + entrée offset
else if the selection is a dessert
    output = dessert value + dessert offset
```

### Decode

```
if input > maximum value
    error
else if input > dessert offset
    dessert = input - dessert offset
else if input > entrée offset
    entrée = input - entrée offset
else if input > 0
    appetizer = input
else
    no menu selection
```
