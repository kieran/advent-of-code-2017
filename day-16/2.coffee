input = require './input'
{ assert, time, timeEnd, log } = console

class Dance
  constructor: (@length)->
    @line = "abcdefghijklmnopqrstuvwxyz".slice(0,@length).split ''

    # keep track of states we've seen before
    @history = [@toString()]

  process: (input, repeat=1)->
    pat = /([sxp])(\d+|\w)(?:\/(\d+|\w)?)?/g

    # Collect the steps to run,
    # no need to parse the input N times
    steps = []
    while match = pat.exec input
      [_, fn, args...] = match
      steps.push [fn, args]

    # Run the steps `repeat` times
    i = 0
    while i++ < repeat

      # run the steps
      for step in steps
        [fn, args] = step
        @[fn].apply @, args

      # if we've seen this state before,
      # we know that the steps are cyclical
      # and will repeat every `i` cycles
      if (str = @toString()) in @history
        # now that we've identified the loop
        # the last element is already
        # in our history. Skip there
        @line = @history[repeat % i].split ''
        return @

      @history.push str
    @

  # Spin, written sX, makes X programs
  # move from the end to the front,
  # but maintain their order otherwise.
  # (For example, s3 on abcde produces cdeab).
  s: (num)->
    # 1000 takes 1.866ms
    # for i in [0...num]
    #   @line.unshift @line.pop()

    # 1000 takes 0.987ms  - LOL dosn't even matter anymore
    @line = @line.slice(@length-num).concat @line.slice(0,@length-num)


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

log (new Dance(16)).process(input,1000000000).toString()


###
  Tests
###

input = "s1,x3/4,pe/b"
assert 'baedc' is (new Dance(5)).process(input).toString()
assert 'ceadb' is (new Dance(5)).process(input,2).toString()
