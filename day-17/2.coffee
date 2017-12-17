{ assert, time, timeEnd, log } = console

class CircularBuffer
  constructor: (@size, @pos=0, @secondVal)->

  step: (num=1)->
    i = 0
    while i++ < num

      # advance the position by @size
      @pos = (@pos + @size) % i

      # 0 is always in the first position,
      # so we know that the value after 0
      # will only ever be written if @pos
      # is 0. We track that here:
      @secondVal = i if @pos is 0

      # advance the position to
      # where the inserted value
      # would have been
      @pos++

    @


###
  Answer
###

log (new CircularBuffer 337).step(50000000).secondVal
