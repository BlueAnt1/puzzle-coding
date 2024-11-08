# ``Sudoku/Version/versionB``

An encoded value looks like: 

`S9B001f0b0165050f000i01040f0f00000607000008000h0002040c00cq06035007gh4m010b090hca000b00gg0003gh01990g094h050200001607020a0a0b080b0i0206000c00fh0305000a8h043g090efhbh`

## Format

- term `S`: the puzzle type.
- term `9`: the size of the puzzle expressed as the number of cells in a row or column (base 32).
- term `B`: the encoding version.

The remainder of the encoding is <doc:CellContentTransform>.

