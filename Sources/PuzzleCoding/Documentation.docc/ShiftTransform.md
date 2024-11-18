# Shift Transform

Transform a group of values into an integer.

## Overview

This transform allows us to store multiple values in adjacent bits of an integer.

## Details

The concept is to reserve adjacent bits in an integer for each type of data. In order to do this we need to know the ranges of values for each data type.

The general strategy is:

- Adjust all ranges & values to start at zero; this could save a few bits.
- Reserve enough space in the output to store the largest value in each range.

### Set up

We need to determine the bits to reserve for each data type. To do this we need as input
the ranges of values permitted for each data type.

@TabNavigator {
    @Tab("Transform") {
        ```
        ranges = [m...n, o...p, ...]
        // shift toward zero by subtracting the range's lower bound from the upper bound
        maxValues = [n - m, p - o, ...]
        // the number of bits to store each maxValue
        bitCounts = [maxValues[0].bitCount, maxValues[1].bitCount, ...]
        // we're going to shift values into the output, but we don't shift the first value, so
        // zero the first value's bit count
        shifts = [0, bitCounts[1], bitCounts[2], ...]
        // calculate the maximum value we'll produce in order to provide this to later transforms or codings
        maxValue = 0
        for index in shifts.indices
            maxValue = (maxValue << shifts[index]) + maxValues[index]
        ```
    }
    @Tab("Example") {
        We want to store an annual reminder. The reminder time should store:

        - The month in the range 1...12.
        - The day of the month in the range 1...31.
        - The hour in the range 0...23.

        ```
        ranges = [1...12, 1...31, 0...23]
        // shift toward zero by subtracting the range's lower bound from the upper bound
        maxValues = [11, 30, 23]
        // the number of bits to store each maxValue
        bitCounts = [4, 5, 5]
        // we're going to shift values into the output, but we don't shift the first value, so
        // zero the first value's bit count
        shifts = [0, 5, 5]
        // calculate the maximum value we'll produce in order to provide this to later transforms or codings
        maxValue = 0
        for index in shifts.indices
            maxValue = (maxValue << shifts[index]) + maxValues[index]
        // maxValue = 12247
        ```
        
        `maxValue` is used by <doc:FieldCoding> to determine the output field width. For this example it results in a field width of 3 characters.
    }
}

### Encode

When encoding we need a set of values, one for each data type.

@TabNavigator {
    @Tab("Transform") {
        ```
        output = 0
        for index in input.indices
            output = (output << shifts[index]) + input[index] - ranges[index].lowerBound
        ```
    }
    @Tab("Example") {
        ```
        month = 5
        day = 1
        hour = 15
        input = [month, day, hour]

        index: 0
            output = (0 << 0) + 5 - 1 = 4
        index: 1
            output = (4 << 5) + 1 - 1 = 128
        index: 2
            output = (128 << 5) + 15 - 0 = 4096 + 15 = 4111
        ```
    }
}

### Decode

Decoding produces one value for each data type. We do this in reverse to take the integer apart from the end.

@TabNavigator {
    @Tab("Transform") {
        ```
        output = []
        // shift values out of the end of the input
        for index in reverse(shifts.indices)
            if shifts[index] == 0
                value = input + ranges[index].lowerBound
            else
                mask = (1 << shifts[index]) - 1  // a contiguous bunch of 1 bits
                value = (input & mask) + ranges[index].lowerBound
            insert value at the start of output
            input = input >> shifts[index]
        ```
    }
    @Tab("Example") {
        ```
        input = 4111
        index: 2
            mask = (1 << 5) - 1 = 32 - 1 = 31 (binary 11111)
            value = (4111 & 31) + 0 = 15
            output = [15]
            input = input >> 5 = 128
        index: 1
            mask = (1 << 5) - 1 = 32 - 1 = 31
            value = (128 & 31) + 1 = 0 + 1 = 1
            output = [1, 15]
            input = 128 >> 5 = 4
        index: 0
            value = 4 + 1 = 5
            output = [5, 1, 15]
        ```
    }
}
