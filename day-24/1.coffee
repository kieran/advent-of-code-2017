input = require './input'
{ assert, time, timeEnd, log } = console

# all possible bridge futures (dimensions)
class Realities
  constructor: (input, @dims=[])->
    tiles = (new Tile line for line in input.split '\n')
    for tile in tiles when tile.accepts 0
      @dims.push b for b in Bridge.construct [tile], tile.opposite(0), (t for t in tiles when t isnt tile)

  # find the strongest bridge in the collection
  strongest: ->
    @dims
    .sort (a,b)-> a.score - b.score
    .reverse()[0]


# a single bridge
class Bridge
  constructor: (@tiles=[], @port, @bag=[])->
    @score = @tiles.reduce ((m, t)-> m + t.score), 0

  # constructs all possible bridges
  # given what's left in the bag
  @construct: (tiles=[], port, bag=[])->
    bridge = new Bridge tiles, port, bag
    exts = [bridge]
    exts.push b for b in bridge.extend tile for tile in bridge.bag when tile.accepts bridge.port
    exts

  # extends the current bridge with
  # the tiles available in the bag
  extend: (tile)->
    tiles = @tiles.slice()
    tiles.push tile
    port = tile.opposite @port
    bag = (t for t in @bag when t isnt tile)
    Bridge.construct tiles, port, bag

# a tile, with a left and right port
class Tile
  constructor: (str)->
    [@left, @right] = str.split('/').map (s)-> parseInt s, 10
    @score = @left + @right

  # does this tile accept a
  # connection to `port`?
  accepts: (port)->
    port in [@left, @right]

  # the port opposite `port`
  opposite: (port)->
    if @left is port then @right else @left


###
  Answer
###

log (new Realities input).strongest().score


###
  Tests
###

input = """
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
"""

assert 31 is (new Realities input).strongest().score
