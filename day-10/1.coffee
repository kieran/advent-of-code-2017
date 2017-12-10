assert = console.assert
input = require './input'

class Knot
  constructor: (@size=256, @pos=0, @skip=0)->
    @arr = [0...@size]

  process: (str)->
    lengths = (parseInt i for i in str.split ',')
    @move i for i in lengths
    @output()

  output: ->
    @arr[0] * @arr[1]

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

input = "3,4,1,5"

assert 12 is (new Knot(5)).process input
