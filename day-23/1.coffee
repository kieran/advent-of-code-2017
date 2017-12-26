input = require './input'
{ assert, time, timeEnd, log } = console

class Proc
  constructor: ->
    # hash with default value of 0
    @regs = new Proxy {},
      get: (obj, prop)->
        if obj.hasOwnProperty prop
          obj[prop]
        else
          0

    @cursor = 0
    @muls = 0

  read: (val)->
    # strings are keys
    return @regs[val] if /[a-z]/.test val
    # numbers should be sanitized
    parseInt val

  @process: (input)->
    (new @).process input.split /\n/

  process: (steps)->
    while @cursor < steps.length
      [fn, reg, val] = steps[@cursor].split ' '

      switch fn
        when 'set'
          @regs[reg] = @read val
        when 'sub'
          @regs[reg] -= @read val
        when 'mul'
          @muls++
          @regs[reg] = @regs[reg] * @read val
        when 'jnz'
          unless 0 is @read reg
            @cursor += -1 + @read val
        else
          throw "wat: #{fn}"
      @cursor++
      # log @cursor, fn, reg, @read val

    @




###
  Answer
###

log Proc.process(input).muls
