input = require "./input"

sum = 0

for row in input.split /\n/
  cols = (parseInt num for num in row.split /\s+/)
  cols.sort (a,b)-> a - b

  for col, idx in cols
    [num, rest...] = cols.slice idx
    for comp in rest
      if comp % col is 0
        sum += comp / col
        break

console.log sum
