# Offset Transform

Transform mutually exclusive values into an integer.

## Overview

This transform allows us to store multiple types of data using the *same set of bits* since only one of the types of data is ever present at a time. We represent the different data types using different ranges of values.

>Note: Offset transform is not used directly, rather it is a transform type that is implemented by transforms tuned to the data requirements.

The offset transform is implemented by <doc:CellContentTransform>, <doc:KenCageContentTransform> and <doc:KillerCageContentTransform>.

## Details

The concept is that we force the values we need to represent into distinct value ranges.

### Example

We need to describe 3 distinct value types: bicycles, cars and trucks. We have 10 bicycles, 4 cars and 7 trucks to represent. A person can drive at most one of the vehicles at a time.

To represent these values we use offsets. Let's represent bicycles with the values `1…10`.

We'll then define the cars offset as the maximum bicycle value: 10.
The range of cars is (car offset + 1)…(car offset + 4) or `11…14`.

The truck offset is the maximum car value: 14. The truck range is (truck offset + 1)…(truck offset + 7) or `15…21`. 

No vehicle selection is represented as 0. The maximum value we represent is 21.

### Encode

```
if there is no vehicle selection
    output = 0
else if the selection is a bicycle
    output = bicycle value
else if the selection is a car
    output = car value + car offset
else if the selection is a truck
    output = truck value + truck offset
```

### Decode

```
if input > maximum value
    error
else if input > truck offset
    truck = input - truck offset
else if input > car offset
    car = input - car offset
else if input > 0
    bicycle = input
else
    no vehicle selection
```
