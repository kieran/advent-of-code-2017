assert = console.assert
input = require './input'

###
  From: http://adventofcode.com/2017/day/3

  Example square:

  147  142  133  122   59
  304    5    4    2   57
  330   10    1    1   54
  351   11   23   25   26
  362  747  806--->   ...

###

class Spiral
  constructor: ->
    @dir = 'right'
    @x = 0
    @y = 0
    @write @x, @y, 1

  @nextAfter: (input)->
    inst = new @
    inst.move() until inst.read() > input
    inst.read()

  # safely write to a cell
  write: (x,y,val)->
    @board ?= []
    @board[x] ?= []
    @board[x][y] = val

  # safely read from a cell,
  # defaulting to 0 for the value
  #
  # without input, it will read
  # the cursor position
  read: (x=@x,y=@y)->
    @board[x]?[y] or 0

  # collect the sum of all 9
  # adjacent cells (inclusive)
  sum: ->
    ret = 0
    for x in [(@x-1)..(@x+1)]
      for y in [(@y-1)..(@y+1)]
        ret += @read x, y
    ret

  # advance the state by 1
  move: ->
    switch @dir
      when 'right'
        unless @read @x, @y+1
          @dir = 'up'
          @y+=1
        else
          @x+=1
      when 'up'
        unless @read @x-1, @y
          @dir = 'left'
          @x-=1
        else
          @y+=1
      when 'left'
        unless @read @x, @y-1
          @dir = 'down'
          @y-=1
        else
          @x-=1
      when 'down'
        unless @read @x+1, @y
          @dir = 'right'
          @x+=1
        else
          @y-=1
    @write @x, @y, @sum()


###
 answer
###

console.log Spiral.nextAfter input


###
  Tests
###

# from example data:
vals = '1 1 2 4 5 10 11 23 25 26 54 57 59 122 133 142 147 304 330 351 362 747 806'.split ' '

# test move coords
s = new Spiral
for val in vals
  assert s.read() is parseInt val
  s.move()
