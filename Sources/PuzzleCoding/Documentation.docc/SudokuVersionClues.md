# ``Sudoku/Version/clue``

An encoded value looks like: 

`...1.5...14....67..8...24...63.7..1.9.......3.1..9.52...72...8..26....35...4.9...`

## Algorithm

```
for every cell in the grid
    if the cell is empty or contains candidates output "."
    else if the cell is a clue or value output the number
```
