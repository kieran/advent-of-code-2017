input = require './input'
{ assert, time, timeEnd, log } = console

class Duet
  constructor: ->
    # hash with default value of 0
    @regs = new Proxy {},
      get: (obj, prop)->
        if obj.hasOwnProperty prop
          obj[prop]
        else
          0

    @sounds = []
    @cursor = 0

  read: (val)->
    # strings are keys
    return @regs[val] if /[a-z]/.test val
    # numbers should be sanitized
    parseInt val

  lastSound: ->
    @sounds[@sounds.length-1]

  @process: (input)->
    (new @).process input.split /\n/

  process: (steps)->
    while @cursor < steps.length
      [fn, reg, val] = steps[@cursor].split ' '

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
          @sounds.push @regs[reg]
        when 'rcv'
          if val = @read reg
            @sounds.push @lastSound()
            return @
        when 'jgz'
          if 0 < @read reg
            @cursor += @read val
            continue

      @cursor += 1

    @


###
  Answer
###

log Duet.process(input).lastSound()


###
  Tests
###

input = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""

assert 4 is Duet.process(input).lastSound()
