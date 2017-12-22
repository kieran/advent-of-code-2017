input = require './input'
{ assert, time, timeEnd, log } = console

###
  Utility functions
###

DIRS = 'nesw'.split ''

# string -> array
s2a = (str)->
  str
  .split '\n'
  .map (row)->
    row
    .split ''
    .map (v)->
      v is '#'


class Virus
  constructor: (@board)->
    @infections = 0
    @dir = 'n'

  @parse: (input)->
    new @ new Board s2a input

  step: (times=1)->
    for i in [0...times]
      if @board.read()
        @turn 1
      else
        @turn -1
      @infect()
      @board.move @dir
    @

  # (un)?infect the cell
  infect: ->
    @infections++ unless @board.read()
    @board.write not @board.read()

  # turn X steps clockwise
  turn: (clock=1)->
    @dir = DIRS[(4 + clock + DIRS.indexOf @dir) % 4]


class Board
  constructor: (@grid=[[]])->
    # start in the center
    @x = Math.floor @grid[0].length / 2
    @y = Math.floor @grid.length / 2

  read: ->
    @grid[@x][@y]

  write: (val)->
    @grid[@x][@y] = not not val

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
      row.unshift false
      row.push false
    # add top and bottom row
    @grid.unshift Array(@grid[0].length).fill false
    @grid.push new Array(@grid[0].length).fill false
    @

  print: ->
    log ''
    for row, i in @grid
      line = []
      for col, j in row
        if i is @x and j is @y
          line.push if col then 'X' else 'O'
        else
          line.push if col then '#' else '.'
      log line.join ''


###
  Answer
###

log Virus.parse(input).step(10000).infections


###
  Tests
###

input = """
..#
#..
...
"""

assert 5 is Virus.parse(input).step(7).infections
assert 41 is Virus.parse(input).step(70).infections
