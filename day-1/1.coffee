input = require './input'

sum = 0

for val, idx in input.split ''
  if val is input[ (idx+1) % input.length ]
    sum += parseInt val

console.log sum
