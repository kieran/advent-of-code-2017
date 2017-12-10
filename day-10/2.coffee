assert = console.assert
input = require './input'

class Knot
  constructor: (@size=256, @pos=0, @skip=0)->
    @arr = [0...@size]

  process: (str)->
    # get ascii codes from each char in the string
    lengths = (i.charCodeAt(0) for i in str.split '')

    # add the 5 lengths from the question
    lengths.push 17, 31, 73, 47, 23

    # run the loop 64 times
    for i in [0...64]
      @move length for length in lengths

    # calculate the output
    @output()

  # returns the hex version of the
  # "dense hash", below
  output: ->
    @dense_hash()
    .map (v)->
      # in JS, the resulting hex number
      # is not necessarily zero-padded,
      # so we have to manually pad it
      "0#{v.toString 16}".slice -2
    .join ''

  # this dense hash is the array
  # with each block of 16 elements XOR'd
  # into a single number
  dense_hash: ->
    ret = []
    for i in [0..255] by 16
      ret.push @arr[i...(i+16)].reduce (m, val)->
        m ^ val
    ret

  # safe reader that loops around
  read: (pos)->
    @arr[pos % @size]

  # safe writer that loops around
  write: (pos, val)->
    @arr[pos % @size] = val

  # the main iteration function
  move: (length)->
    # Reverse the order of that length of elements in the list,
    # starting with the element at the current position.

    vals = []

    # read in the values we're changing
    for i in [@pos...(@pos + length)]
      vals.push @read i

    # write the values back in reverse
    for i in [@pos...(@pos + length)]
      @write i, vals.pop()

    # Move the current position forward by that length plus the skip size
    @pos += length + @skip

    # Increase the skip size by one.
    @skip++


###
  Answer
###

console.log (new Knot).process input


###
  Tests
###

assert 'a2582a3a0e66e6e86e3812dcb672a272' is (new Knot).process ''
assert '33efeb34ea91902bb2f59c9920caa6cd' is (new Knot).process 'AoC 2017'
assert '3efbe78a8d82f29979031a4aa0b16a9d' is (new Knot).process '1,2,3'
assert '63960835bcdc130f0b66d7ff4f6a5a8e' is (new Knot).process '1,2,4'
