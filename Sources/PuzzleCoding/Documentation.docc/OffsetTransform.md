# Offset Transform

Transform mutually exclusive values into an integer.

## Overview

This transform allows us to store multiple types of data using the *same set of bits* since only one of the types of data is ever present at a time. We represent the different data types using different ranges of values.

>Note: Offset transform is not used directly, rather it is a transform type that is implemented by transforms tuned to the data requirements.

The offset transform is implemented by <doc:CellContentTransform>.

## Details

The concept is that we force the values we need to represent into distinct value ranges.

### Example

We need to describe 3 distinct value types: bicycles, motorcycles and cars. We have 10 bicycles, 4 motorcycles and 7 cars to represent. A person can drive at most one of the vehicles at a time.

To represent these values we use offsets. Let's represent bicycles with the values `1…10`.

We'll then define the motorcycle offset as the maximum bicycle value: 10.
The range of motorcycles is (motorcycle offset + 1)…(motorcycle offset + 4) or `11…14`.

The car offset is the maximum motorcycle value: 14. The car range is (car offset + 1)…(car offset + 7) or `15…21`. 

No vehicle selection is represented as 0. The maximum value we represent is 21.

### Encode

```
if there is no vehicle selection
    output = 0
else if the selection is a bicycle
    output = bicycle value
else if the selection is a motorcycle
    output = motorcycle value + motorcycle offset
else if the selection is a car
    output = car value + car offset
```

### Decode

```
if input > maximum value
    error
else if input > car offset
    car = input - car offset
else if input > motorcycle offset
    motorcycle = input - motorcycle offset
else if input > 0
    bicycle = input
else
    no vehicle selection
```
