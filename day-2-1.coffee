input = require "./day-2-input.coffee"

sum = 0

for row in input.split /\n/
  cols = (parseInt num for num in row.split /\s+/)
  cols.sort (a,b)-> a - b
  [min, ..., max] = cols
  sum += max - min

console.log sum
