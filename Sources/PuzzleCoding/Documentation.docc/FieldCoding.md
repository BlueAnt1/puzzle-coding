# Field Coding

Code values using fixed width fields.

## Overview

Values are coded in fixed width fields.

The fields:
- represent integer values
- are coded in a radix ranging from 2...36
- are leading zero padded to the field width

## Details

The radix is generally 36.

### Set up

```
maxValue = maximum value that can be stored in the field
maxEncodedValue = convert maxValue to the radix
fieldWidth = the number of characters in maxEncodedValue
```

### Encode

```
input = value to encode
encodedValue = input converted to the radix
output = pad encodedValue to fieldWidth with leading zeroes
```

### Decode

```
input = fieldWidth number of characters to decode
output = convert input from the radix
```
