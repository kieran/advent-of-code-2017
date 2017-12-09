assert = console.assert
input = require './input'

###
  From: http://adventofcode.com/2017/day/3

  Example square:

  17  16  15  14  13
  18   5   4   3  12
  19   6   1   2  11
  20   7   8   9  10
  21  22  23---> ...

###

class Ring
  constructor: (@width=1)->
    # ensure we only construct well
    # structured rings (odd widths)
    assert @width % 2 is 1, "width must be odd"

    # pre-compute min/max X & Y
    @maxX = @maxY = Math.floor @width / 2
    @minX = @minY = 0 - @maxX

    # area, circumference
    @area = Math.pow @width, 2
    @circ = Math.max 1, (@width - 1) * 4

    # min, max values in ring
    @min = @area - @circ + 1
    @max = @area

  # find the ring that contains this number
  @forNumber: (num)->
    # find the width of the largest square
    # which contains the number
    width = Math.ceil Math.sqrt num

    # if that width is even, we need to expand
    # the width by 1 to make it odd
    # since the inner-most square is 1x1
    width = width + 1 if width % 2 is 0

    # return a new Ring object for that square
    new Ring width

  # find the manhattan distance from the
  # number to the center of the ring
  @distanceFor: (num)->
    @forNumber num
    .distanceFor num

  #
  # Searches around the ring in insertion
  # order for the correct number, returning
  # the coords of the first match
  #
  coordsFor: (num)->
    # always starts one up from
    # the bottom right corner
    [x, y] = [ @maxX, Math.min 0, @minY + 1 ]

    # start the cursor at the min
    current = @min

    # and return immediately if
    # this is the target number
    return [x,y] if current is num

    # move up until max Y
    while y < @maxY
      y += 1
      current += 1
      return [x,y] if current is num

    # move left until min X
    while x > @minX
      x -= 1
      current += 1
      return [x,y] if current is num

    # move down until min Y
    while y > @minY
      y -= 1
      current += 1
      return [x,y] if current is num

    # move right until max X
    while x < @maxX
      x += 1
      current += 1
      return [x,y] if current is num

    throw "¿WTF num #{num} not found?"

  distanceFor: (num)->
    @coordsFor num
    .map Math.abs
    .reduce (memo, val)->
      memo + val

###
  Answer question 1
###

console.log "Distance for #{input} is #{Ring.distanceFor input}"


###
  Tests
###

# Ring.forNumber
sizes =
  1: 1
  9: 3
  10: 5
  25: 5
  26: 7

for num, width of sizes
  assert Ring.forNumber(num).width is width, "Expected ring for #{num} to be #{width}"

# ring.coordsFor num
assert (new Ring(1)).coordsFor(1).toString() is [0,0].toString()
assert (new Ring(3)).coordsFor(3).toString() is [1,1].toString()
assert (new Ring(3)).coordsFor(9).toString() is [1,-1].toString()
assert (new Ring(5)).coordsFor(22).toString() is [-1,-2].toString()

# Ring.distanceFor num
assert Ring.distanceFor(1) is 0
assert Ring.distanceFor(3) is 2
assert Ring.distanceFor(9) is 2
assert Ring.distanceFor(22) is 3
