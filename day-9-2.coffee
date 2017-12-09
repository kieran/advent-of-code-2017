input = require './day-9-input.coffee'

score = (str)->
  ignore = false
  garbage = false
  garbage_count = 0

  for i in [0..str.length-1]
    char = str[i]

    switch
      when ignore
        # ignore this char
        ignore = false
      when char is '!'
        # ignore next char
        ignore = true
      when garbage
        # continue garbage mode?
        if char is '>'
          garbage = false
        else
          garbage_count++
      when char is '<'
        # start garbage mode
        garbage = true

  garbage_count


###
  Answer
###

console.log score input
