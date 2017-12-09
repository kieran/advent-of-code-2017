assert = console.assert
input = require './input'

check = (phrase='')->
  words =
    phrase
    .split /\s+/    # split the phrase into words
    .map (w)->      # sort the letters of each word
      w
      .split ''
      .sort()
      .join ''
    .sort()         # sort the final phrase

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

assert check 'abcde fghij'
assert not check 'abcde xyz ecdab'
assert check 'a ab abc abd abf abj'
assert check 'iiii oiii ooii oooi oooo'
assert not check 'oiii ioii iioi iiio'
