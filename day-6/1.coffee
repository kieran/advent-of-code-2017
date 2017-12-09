assert = console.assert
input = require './input'

realloc = (input='')->
  # our array of memory banks
  banks   = (parseInt n for n in input.split /\s+/)

  # memory states we've seen
  # added as a serialized key
  states  = [ banks.join '-' ]

  while true
    # find the position & value
    # of the highest memory bank
    idx = banks.indexOf Math.max banks...
    val = banks[idx]

    # clear the bank
    banks[idx] = 0

    # re-distribute the blocks
    while 0 < val--
      idx = ++idx % banks.length
      banks[idx]++

    # generate the new state key
    # check if we've seen it before
    state = banks.join '-'
    return states.length if state in states

    # record as seen and continue the loop
    states.push state


###
  Answer
###

console.log realloc input


###
  Tests
###

input = "0 2 7 0"

assert 5 is realloc input
