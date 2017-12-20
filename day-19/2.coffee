input = require './input'
{ assert, time, timeEnd, log } = console

class Navi
  constructor: (input, @letters=[])->
    @grid = []

    for line in input.split '\n'
      @grid.push line = line.split ''

    # find entry point
    [@x,@y] = [-1, @grid[0].indexOf('|')]
    @dir = 's'

    @steps = 0

    loop
      break unless @step()

    @


  step: ->
    switch @dir
      when 'n'
        @x--
      when 's'
        @x++
      when 'e'
        @y++
      when 'w'
        @y--
    # log @dir, @x, @y, @grid[@x]?[@y]

    val = @grid[@x]?[@y]
    switch
      when val is '+'
        if @dir in ['n','s'] then @yturn() else @xturn()
      when val in [' ', undefined]
        return false
      when /[A-Z]/.test val
        @letters.push val
    @steps++
    true

  xturn: ->
    # figure out new direction
    if /[A-Z|]/.test @grid[@x+1]?[@y]
      @dir = 's'
    else if /[A-Z|]/.test @grid[@x-1]?[@y]
      @dir = 'n'
    else if @grid[@x+1]?[@y]
      @dir = 's'
    else if @grid[@x-1]?[@y]
      @dir = 'n'
    else
      throw 'could not determine x turn direction'

  yturn: ->
    # figure out new direction
    if /[A-Z-]/.test @grid[@x]?[@y-1]
      @dir = 'w'
    else if /[A-Z-]/.test @grid[@x]?[@y+1]
      @dir = 'e'
    else if @grid[@x]?[@y-1]
      @dir = 'w'
    else if @grid[@x]?[@y+1]
      @dir = 'e'
    else
      throw 'could not determine y turn direction'


  waypoints: ->
    @letters.join ''


###
  Answer
###

log (new Navi input).steps


###
  Tests
###

input = """
     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
"""

assert 38 is (new Navi input).steps
