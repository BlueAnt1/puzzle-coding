# ``Sudoku/Version/offset``

An encoded value looks like: 

`S33epe1ep010i05ep8r0q01040g0c0e0c06070ce9080c1m0i02043gas0h06030g072oem010b090k0e0a3x0c7l0g030c010b8v09e9050242ai0e07020c0ab608d80a0206dr0ge59g03050e0iea040b094mbj0f`

## Format

- term `S`: the encoding version, case is significant.
- term `33`: the shape of a grid box specified as two base 10 digits indicating the number of rows & columns in a box.

The remainder of the encoding uses the <doc:OffsetGridAlgorithm>.

