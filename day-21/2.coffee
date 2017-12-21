input = require './input'
{ assert, time, timeEnd, log } = console

###
  Utility functions
###

# string -> array
s2a = (str)->
  str
  .split '/'
  .map (seg)->
    seg.split ''

# array -> string
a2s = (arr)->
  arr
  .map (seg)->
    seg.join ''
  .join '/'

# array -> text grid for visual deugging
a2debug = (arr)->
  arr
  .map (seg)->
    seg.join ''
  .join '\n'

# flips an array, left <-> right
flip = (arr)->
  arr
  .map (row)->
    row.reverse()

# rotates an array, clockwise
rotate = (arr)->
  copy = JSON.parse JSON.stringify arr
  for i in [0..(arr.length-1)]
    for j in [0..(arr.length-1)]
      copy[i][j] = arr[arr.length-1-j][i]
  copy


# An art
class Art
  constructor: (rules)->
    # starter grid
    @grid = [
      '.#.'.split ''
      '..#'.split ''
      '###'.split ''
    ]

    @rules = (new Rule line for line in rules.split '\n')
    @

  # enhances the art by 1 step
  step: ->
    for size in [2,3]
      if 0 is @grid.length % size
        @grid = @process size
        return @

  # processes the grid
  # in groups of `size`
  #
  # returns the new state
  # of the grid
  process: (size)->

    # step 1:
    # build a temp array
    # full of replacement tiles
    temp = []
    for i in [0..(@grid.length-1)] by size
      temp_row = []
      for j in [0..(@grid.length-1)] by size
        arr = @slice i, j, size
        for rule in @rules
          if out = rule.match arr
            temp_row.push out
            continue
      temp.push temp_row

    # step 2:
    # re-constitute the new grid of grids
    # into a single grid. Kind of a
    # shitty 2-d flatten function
    ret = []
    for row, i in temp
      for tile, j in row
        for tile_row, ti in tile
          witdh = tile.length
          ret[i*witdh+ti] ||= []
          for tile_col, tj in tile_row
            ret[i*witdh+ti][j*witdh+tj] = tile_col
    ret

  # slices a `size`-sized tile
  # out the grid at the coords of
  # [ row, col ]
  slice: (row, col, size)->
    @grid.slice(row, row+size).map (row)->
      row.slice col, col+size

  # counts the number of '#'
  # chars in the grid
  num_on: ->
    count = 0
    for row in @grid
      for col in row
        count++ if col is '#'
    count

# a replacement rule
class Rule
  constructor: (line)->
    [before, after] = line.split ' => '

    tile = s2a before

    # create an array of all possible matches
    # ugly, not-deduped
    @matches = [before]
    @matches.push a2s flip tile
    @matches.push a2s rotate tile
    @matches.push a2s flip rotate tile
    @matches.push a2s rotate rotate tile
    @matches.push a2s flip rotate rotate tile
    @matches.push a2s rotate rotate rotate tile
    @matches.push a2s flip rotate rotate rotate tile

    @replace = s2a after

  # if the input tile matches this rule
  # then return the replacement tile
  match: (arr)->
    @replace if a2s(arr) in @matches


###
  Answer
###

art = new Art input
for i in [0...18]
  time i
  art.step()
  timeEnd i
log art.num_on()


###
  Tests
###

# flip
assert '.#./#../###' is a2s flip s2a '.#./..#/###'
assert '.#./..#/###' is a2s flip flip s2a '.#./..#/###'

# rotate
assert '.#/..' is a2s rotate s2a '#./..'
assert '../.#' is a2s rotate rotate s2a '#./..'
assert '../#.' is a2s rotate rotate rotate s2a '#./..'
assert '#./..' is a2s rotate rotate rotate rotate s2a '#./..'


input = """
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
"""

assert """
#..#
....
....
#..#
""" is a2debug (new Art input).step().grid

assert """
##.##.
#..#..
......
##.##.
#..#..
......
""" is a2debug (new Art input).step().step().grid
