# Pack Candidates

Pack candidates into an integer.

## Overview

This is a compression algorithm that converts a set of candidates into a single integer.

Treat each candidate value as a bit position and turn that bit on. Bit `1` is the least significant bit.

Using the candidates `[4, 3, 1]` as an example, set those bits to one: `1101` and interpret as an integer: `13`.

## Pack

```
packed = 0
for each candidate
    packed = packed | (1 << (candidate - 1))
```

## Unpack

```
candidates = []
candidate = 1
while packed > 0
    if packed & 1 == 1
        insert candidate into candidates
    candidate = candidate + 1
    packed = packed >> 1
```
