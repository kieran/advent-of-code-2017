assert = console.assert
input = require './day-8-input.coffee'

pat = ///
  (\w+)        # register
  \s+
  (\w+)        # method
  \s+
  (-?\d+)      # value
  \s+if\s
  (\w+)        # register
  \s+
  ([!=<>]+)    # comparitor
  \s+
  (-?\d+)      # value
///


class CPU
  constructor: (input='', @registers={}, @max=0)->
    for line in input.split '\n'
      [match, args...] = line.match pat
      @eval args...

  register: (name)->
    @registers[name] ||= new Register name

  eval: (r, m, v, r2, c, v2)->
    if @register(r2)[c] v2
      @max = Math.max @max, @register(r)[m] v

  largest: ->
    Object.values @registers
    .sort (a,b)->
      a.value -
      b.value
    .pop()

class Register
  constructor: (@name, @value=0)->

  inc: (val)->
    @value += parseInt val

  dec: (val)->
    @value -= parseInt val

  '>': (v)->
    @value > parseInt v

  '<': (v)->
    @value < parseInt v

  '==': (v)->
    @value == parseInt v

  '>=': (v)->
    @value >= parseInt v

  '<=': (v)->
    @value <= parseInt v

  '!=': (v)->
    @value != parseInt v

###
  Answer
###

cpu = new CPU input
console.log cpu.max


###
  Tests
###

# cpu = new CPU

input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

cpu = new CPU input
assert 10 is cpu.max
