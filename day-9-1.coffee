assert = console.assert
input = require './day-9-input.coffee'

sum = (arr)-> arr.reduce (m, el)->
  m += el
, 0

score = (str)->
  ignore = false
  garbage = false
  scores = []
  depth = 0

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
        garbage = char isnt '>'
      when char is '<'
        # start garbage mode
        garbage = true
      when char is '{'
        # start group
        scores.push ++depth
      when char is '}'
        # end group
        depth--

  sum scores


###
  Answer
###

console.log score input


###
  Tests
###

assert 1  is score '{}'
assert 6  is score '{{{}}}'
assert 5  is score '{{},{}}'
assert 16 is score '{{{},{},{{}}}}'
assert 1  is score '{<a>,<a>,<a>,<a>}'
assert 9  is score '{{<ab>},{<ab>},{<ab>},{<ab>}}'
assert 9  is score '{{<!!>},{<!!>},{<!!>},{<!!>}}'
assert 3  is score '{{<a!>},{<a!>},{<a!>},{<ab>}}'
