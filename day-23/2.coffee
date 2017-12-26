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
          if prop is 'a' then 1 else 0

    @cursor = 0
    @muls = 0

  # read: (val)->
  #   # strings are keys
  #   return @regs[val] if /[a-z]/.test val
  #   # numbers should be sanitized
  #   parseInt val

  @process: (input)->
    (new @).process input.split /\n/

  process: (steps)->
    # parse steps once
    @steps = []
    for step in steps
      [fn, reg, val] = step.split ' '
      @steps.push [fn, reg, parseInt val]

    i = 0
    while @cursor < @steps.length
      log i if 0 is ++i % 1000000
      [fn, reg, val] = @steps[@cursor]

      unless reg in ['a','g','f','1']
        @cursor++
        continue

      # unless fn in ['jnz', 'sub']
      #   @cursor++
      #   continue

      # if fn is 'sub'
      #   @regs[reg] -= val if reg is 'h'
      #   @cursor++
      #   continue

      # unless reg in ['a','g','f','l']
      #   @cursor++
      #   continue

      switch fn
        when 'set'
          @regs[reg] = val
        when 'sub'
          @regs[reg] -= val
        when 'mul'
          @muls++
          @regs[reg] = @regs[reg] * val
        when 'jnz'
          if reg is '1' or 0 isnt @regs[reg]
            @cursor += -1 + val
        else
          throw "wat: #{fn}"
      @cursor++
    @




###
  Answer
###

log Proc.process(input).regs.h
