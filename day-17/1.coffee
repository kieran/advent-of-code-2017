{ assert, time, timeEnd, log } = console

class CircularBuffer
  constructor: (@size, @pos=0, @arr=[0])->

  step: (num=1)->
    i = 0
    while i++ < num

      # advance the position by @size
      @pos = (@pos + @size) % i

      # append the next value
      @arr.splice @pos+1, 0, i

      # advance the position to
      # the inserted value
      @pos++

    @

  nextVal: ->
    @arr[(@pos+1) % @arr.length]

  print: ->
    str = ''
    for el, idx in @arr
      if idx is @pos
        str += "(#{el})"
      else
        str += " #{el} "
    log str


###
  Answer
###

log (new CircularBuffer 337).step(2017).nextVal()


###
  Tests
###
assert 5 is (new CircularBuffer 3).step(9).nextVal()
assert 638 is (new CircularBuffer 3).step(2017).nextVal()
