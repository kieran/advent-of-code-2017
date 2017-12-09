assert = console.assert
input = require './input'

escape = (input='')->
  ar = (parseInt n for n in input.split /\n/)

  steps = 0
  cursor = 0

  while true
    return steps unless ar[cursor]?
    steps++
    jumps = ar[cursor]

    # special rules for incrementing
    if jumps >= 3
      ar[cursor]--
    else
      ar[cursor]++

    cursor += jumps


###
  Answer
###

console.log escape input


###
  Tests
###

input = """
0
3
0
1
-3
"""

assert 10 is escape input
