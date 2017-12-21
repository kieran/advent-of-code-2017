input = require './input'
{ assert, time, timeEnd, log } = console

s2a = (str)->
  str
  .split '/'
  .map (seg)->
    seg.split ''

a2s = (arr)->
  arr
  .map (seg)->
    seg.join ''
  .join '/'

a2debug = (arr)->
  arr
  .map (seg)->
    seg.join ''
  .join '\n'

flip = (arr)->
  arr
  .map (row)->
    row.reverse()

rotate = (arr)->
  copy = JSON.parse JSON.stringify arr
  for i in [0..(arr.length-1)]
    for j in [0..(arr.length-1)]
      copy[i][j] = arr[arr.length-1-j][i]
  copy


class Art
  constructor: (rules)->
    @grid = [
      '.#.'.split ''
      '..#'.split ''
      '###'.split ''
    ]

    @rules = (new Rule line for line in rules.split '\n')


  step: ->
    for size in [2,3]
      if 0 is @grid.length % size

        @grid = @process size
        return @
    # throw 'wtf'

  process: (size)->
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

    ret = []
    for row, i in temp
      for tile, j in row
        for tile_row, ti in tile
          witdh = tile.length
          ret[i*witdh+ti] ||= []
          for tile_col, tj in tile_row
            ret[i*witdh+ti][j*witdh+tj] = tile_col
    ret


  slice: (row, col, size)->
    lol = @grid.slice(row, row+size).map (row)->
      row.slice col, col+size

    lol

  num_on: ->
    count = 0
    for row in @grid
      for col in row
        count++ if col is '#'
    count

class Rule
  constructor: (line)->
    [before, after] = line.split ' => '

    @matches = [before]
    tile = s2a before
    @size = tile.length

    @matches.push a2s flip tile
    @matches.push a2s rotate tile
    @matches.push a2s flip rotate tile
    @matches.push a2s rotate rotate tile
    @matches.push a2s flip rotate rotate tile
    @matches.push a2s rotate rotate rotate tile
    @matches.push a2s flip rotate rotate rotate tile

    @replace = s2a after

  match: (arr)->
    if a2s(arr) in @matches
      @replace


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
