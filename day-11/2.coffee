assert = console.assert
input = require './input'

class Hexgrid
  constructor: (@path)->
    @x = 0 # x-axis: up/down
    @y = 0 # y-axis: up-right / down-left
    @z = 0 # z-axis: down-right / up-left

    @max_dist = 0

    for dir in @path.split ','
      switch dir
        when 'n'
          @y++
          @z--
        when 's'
          @y--
          @z++
        when 'ne'
          @x++
          @z--
        when 'sw'
          @x--
          @z++
        when 'se'
          @x++
          @y--
        when 'nw'
          @x--
          @y++

      @max_dist = Math.max @max_dist, @offset()

  offset: ->
    dists = (Math.abs d for d in [@x, @y, @z])
    Math.max dists...


###
  Answer
###

console.log (new Hexgrid input).max_dist


###
  Tests
###

assert 3 is (new Hexgrid 'ne,ne,ne').offset()
assert 0 is (new Hexgrid 'ne,ne,sw,sw').offset()
assert 2 is (new Hexgrid 'ne,ne,s,s').offset()
assert 3 is (new Hexgrid 'se,sw,se,sw,sw').offset()
