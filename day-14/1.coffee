assert = console.assert
Knot = require './knot'

hex2bin = (hex)->
  parseInt hex, 16
  .toString 2

class Disk
  constructor: (input='', @bitmap='')->
    for i in [0..127]
      @bitmap +=
      (new Knot)
      .process [input, i].join '-'
      .split ''
      .map hex2bin
      .join ''

  used: ->
    (s for s in @bitmap.split('') when s is '1').length


###
  Answer
###

input = 'ljoxqyyw'
console.log (new Disk input).used()


###
  Tests
###

input = "flqrgnkx"
assert 8108 is (new Disk input).used()
