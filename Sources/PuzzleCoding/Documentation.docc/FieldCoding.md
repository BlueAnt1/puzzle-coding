# Field Coding

Code values using fixed width fields.

## Overview

The fields:

- represent integer values.
- are coded in base 36 characters (the radix).
- are leading zero padded to the field width.

## Details

### Set up

```
maxValue = maximum value that can be stored in the field
maxEncodedValue = convert maxValue to the radix
fieldWidth = the number of characters in maxEncodedValue
```

### Encode

```
input = value to encode
encodedValue = convert input to the radix
output = pad encodedValue to fieldWidth with leading zeroes
```

### Decode

```
input = fieldWidth number of characters to decode
output = convert input from the radix
```
