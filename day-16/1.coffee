input = require './input'
{ assert, time, timeEnd, log } = console

class Dance
  constructor: (length)->
    @line = "abcdefghijklmnopqrstuvwxyz".slice(0,length).split ''

  process: (input)->
    pat = /([sxp])(\d+|\w)(?:\/(\d+|\w)?)?/g
    while match = pat.exec input
      [_, fn, args...] = match
      @[fn].apply @, args
    @

  # Spin, written sX, makes X programs
  # move from the end to the front,
  # but maintain their order otherwise.
  # (For example, s3 on abcde produces cdeab).
  s: (num)->
    for i in [0...num]
      @line.unshift @line.pop()

  # Exchange, written xA/B, makes the
  # programs at positions A and B swap places.
  x: (p1, p2)->
    [@line[p1], @line[p2]] = [@line[p2], @line[p1]]

  # Partner, written pA/B, makes the
  # programs named A and B swap places.
  p: (n1,n2)->
    @x @line.indexOf(n1), @line.indexOf(n2)

  toString: ->
    @line.join ''


###
  Answer
###

log (new Dance(16)).process(input).toString()


###
  Tests
###

input = "s1,x3/4,pe/b"
assert 'baedc' is (new Dance(5)).process(input).toString()
