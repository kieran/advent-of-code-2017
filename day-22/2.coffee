input = require './input'
{ assert, time, timeEnd, log } = console

###
  Utility functions
###

DIRS = 'nesw'.split ''
STATES = '.W#F'.split ''

# string -> array
s2a = (str)->
  str
  .split '\n'
  .map (row)->
    row
    .split ''
    .map (v)->
      STATES
      .indexOf v

class Virus
  constructor: (@board)->
    @infections = 0
    @dir = 'n'

  @parse: (input)->
    new @ new Board s2a input

  step: (times=1)->
    for i in [0...times]
      @turn()
      @infect()
      @board.move @dir
    @

  # advance the infection in the current cell
  infect: ->
    @board.infect()
    @infections++ if 2 is @board.read()

  # update the direction
  turn: ->
    @dir = DIRS[(4 + @board.read() - 1 + DIRS.indexOf @dir) % 4]


class Board
  constructor: (@grid=[[]])->
    # start in the center
    @x = Math.floor @grid[0].length / 2
    @y = Math.floor @grid.length / 2

  read: ->
    @grid[@x][@y]

  # advance the infection
  infect: ->
    @grid[@x][@y] = (@grid[@x][@y] + 1) % 4

  # move the cursor by 1
  # in the direction of travel
  move: (dir)->
    switch dir
      when 'n' then @x--
      when 'e' then @y++
      when 's' then @x++
      when 'w' then @y--
    # grow if we're outof bounds
    @grow() unless 0 <= @x < @grid.length
    @grow() unless 0 <= @y < @grid[0].length
    # @print()
    @

  # grow the board by 1 in each direction
  grow: ->
    # adjust the current cursor
    # to compensate for the new 0, 0
    @x++
    @y++
    # add cols to existing rows
    for row in @grid
      row.unshift 0
      row.push 0
    # add top and bottom row
    @grid.unshift Array(@grid[0].length).fill 0
    @grid.push new Array(@grid[0].length).fill 0
    @

  print: ->
    log ''
    for row, i in @grid
      line = []
      for col, j in row
        line.push STATES[col]
      log line.join ''


###
  Answer
###

log Virus.parse(input).step(10000000).infections


###
  Tests
###

input = """
..#
#..
...
"""

assert 26 is Virus.parse(input).step(100).infections
assert 2511944 is Virus.parse(input).step(10000000).infections
