###

  This part is still producing
  the wrong answer: 127

###

input = require './input'
{ assert, time, timeEnd, log } = console

duet = (input)->
  steps = input.split /\n/

  a = new Player 'a', steps
  b = new Player 'b', steps, p: 1

  abuf = null
  bbuf = null
  agen = a.process()
  bgen = b.process()
  until a.waiting and b.waiting and !a.snds.length and !b.snds.length and !a.rcvs.length and !b.rcvs.length
    bbuf = agen.next(abuf).value
    abuf = bgen.next(bbuf).value
  a.sends


class Player
  constructor: (@name, @steps, o={})->
    # hash with default value of 0
    @regs = new Proxy o,
      get: (obj, prop)->
        if obj.hasOwnProperty prop
          obj[prop]
        else
          0

    @cursor = 0
    @sends = 0
    @snds = []
    @

  read: (val)->
    # strings are keys
    return @regs[val] if /[a-z]/.test val
    # numbers should be sanitized
    parseInt val

  process: (@rcvs=[])->
    @snds = []
    while @cursor < @steps.length

      [fn, reg, val] = @steps[@cursor].split ' '

      # log @name, fn, reg, val

      switch fn
        when 'set'
          @regs[reg] = @read val
        when 'add'
          @regs[reg] += @read val
        when 'mul'
          @regs[reg] = @regs[reg] * @read val
        when 'mod'
          @regs[reg] = @regs[reg] % @read val
        when 'snd'
          @sends++
          @snds.push @read reg
        when 'rcv'
          # pause for rcvs
          unless @rcvs.length
            # log @name, 'yielding'
            @waiting = true
            @rcvs = yield @snds.slice()
            @snds = []
          # did we get any rcvs?
          if @rcvs.length
            @waiting = false
            # log @name, "have #{@rcvs.length} rcvs"
            @regs[reg] = @read @rcvs.shift()
          else
            yield @snds.slice()
            @snds = []
        when 'jgz'
          if 0 < @read reg
            @cursor += @read val
            @cursor--
      @cursor++
    @rcvs = yield @snds



###
  Answer
###

log duet input


###
  Tests
###

input = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""
# log duet input

assert 3 is duet input
