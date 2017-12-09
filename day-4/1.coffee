assert = console.assert
input = require './input'

check = (phrase='')->
  words =
    phrase
    .split /\s+/    # split the phrase into words
    .sort()         # sort the phrase

  # bail if a duplicate word is found
  for word, idx in words
    return false if word is words[idx+1]

  # none found, looks good
  true


###
  Answer
###

count = 0
for phrase in input.split /\n/
  count += 1 if check phrase

console.log count


###
  Tests
###

assert check 'aa bb cc dd ee'
assert not check 'aa bb cc dd aa'
assert check 'aa bb cc dd aaa'
