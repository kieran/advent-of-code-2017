input = require './day-1-input.coffee'

sum = 0

for val, idx in input.split ''
  if val is input[ (idx+input.length/2) % input.length ]
    sum += parseInt val

console.log sum
