assert = console.assert
Knot = require './knot'

#
# Convert a hex number to binary
# 4-digits, *** zero-padded! ***
#
hex2bin = (hex=0)->
  "0000#{parseInt(hex, 16).toString 2}".slice -4

class Disk
  constructor: (input='')->
    @cells = Array 128

    # construct
    for i in [0..127]
      @cells[i] =
      (new Knot)
      .process [input, i].join '-'
      .split ''
      .map hex2bin
      .join ''
      .split ''
      .map (v)->  # mark cells as `true` (used)
        v is '1'  # or `false` (empty)

  #
  # iterate the entire disk
  #
  # whenever we find a `true` cell,
  # start a new region and then infect
  # all adjacent used cells with that
  # region label, recursively
  #
  regions: ->
    regions = 0
    for row in [0..127]
      for col in [0..127]
        if @cells[row][col] is true
          @infect row, col, regions++
    # @print()
    regions

  #
  # infects self, adjacent cells with `val`
  # if the current cell hasn't been infected yet
  #
  infect: (row, col, val)->
    return unless @cells[row]?[col] is true

    # infect current cell
    @cells[row][col] = val

    # infect neighbours
    for i in [-1..1]
      for j in [-1..1]

        # ignore diagonals
        continue unless Math.abs(i) ^ Math.abs(j)

        @infect row+i, col+j, val

  #
  # prints a *gigantic*
  # map of the disk with
  # labelled cells
  #
  # ex: https://imgur.com/xW9whyg
  #
  print: (lol)->
    for row in @cells
      str =
      row
      .map (v)->
        "----#{v or ''}".slice -4
      .join ' '

      console.log str


###
  Answer
###

console.log (new Disk 'ljoxqyyw').regions()


###
  Tests
###

assert 1242 is (new Disk 'flqrgnkx').regions()
