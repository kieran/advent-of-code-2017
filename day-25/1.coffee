input = require './input'
{ assert, time, timeEnd, log } = console

# a tape drive, from -Inf to +Inf
# contains a cursor, can compute it's own checksum
class Tape
  constructor: (@pos=[], @neg=[], @cursor=0)->

  read: ->
    if @cursor < 0
      @neg[Math.abs @cursor] or 0
    else
      @pos[@cursor] or 0

  write: (val)->
    if @cursor < 0
      @neg[Math.abs @cursor] = val
    else
      @pos[@cursor] = val

  checksum: ->
    ret = 0
    ret++ for v in @neg when v is 1
    ret++ for v in @pos when v is 1
    ret

# the Turing Machine
# accepts well-formatted, written
# instructions, and runs them
class TuringMachine
  constructor: (input)->
    # install a fresh Tape drive
    @tape = new Tape

    instructions = input.split '\n\n'

    # get the starting state and number of iterations
    [@state, @iterations] = instructions.shift().match /\b([A-Z]|\d+)\b/g
    @iterations = parseInt @iterations

    # parse the instructions
    @instructions = {}
    for str in instructions
      inst = new Instruction str
      @instructions[inst.state] = inst


  run: ->
    i = 0
    while i < @iterations
      val = @tape.read()
      proc = @instructions[@state].procFor @tape.read()
      @tape.write proc.write
      @tape.cursor += proc.add
      @state = proc.next
      i++
    @

# an Instruction
# contains 2 procs: 0 and 1
class Instruction
  constructor: (input)->
    [
      @state,
      in1, out1, dir1, next1,
      in2, out2, dir2, next2
    ] = input.match /\b([0-1]|right|left|[A-Z])\b/g

    @procs = [
      new Proc parseInt(in1), parseInt(out1), dir1, next1
      new Proc parseInt(in2), parseInt(out2), dir2, next2
    ]

  procFor: (value)->
    return proc for proc in @procs when proc.value is value

# a Proc
# basically holds the key info for each proc
class Proc
  constructor: (@value, @write, @dir, @next)->
    @add = if @dir is 'left' then -1 else 1


###
  Answer
###

log (new TuringMachine input).run().tape.checksum()


###
  Tests
###

input = """
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
"""

assert 3 is (new TuringMachine input).run().tape.checksum()
