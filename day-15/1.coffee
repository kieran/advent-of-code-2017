{ assert, time, timeEnd } = console

class Generator
  constructor: (@factor, @value)->

  step: (iterations=1)->
    for i in [0...iterations]
      @value = @value * @factor % 2147483647
    @


###
  Answer
###

console.log do ->
  genA = new Generator 16807, 516
  genB = new Generator 48271, 190

  i = 0
  pairs = 0
  while i++ < 40000000
    pairs++ if genA.step().value % 65536 is genB.step().value % 65536
  pairs


###
  Tests
###

assert 1352636452 is new Generator(16807,65).step(5).value
assert 285222916 is new Generator(48271,8921).step(5).value

# takes ~ 1600 ms
assert 588 is do ->
  # 40 M pair test
  genA = new Generator 16807, 65
  genB = new Generator 48271, 8921

  i = 0
  pairs = 0
  while i++ < 40000000
    pairs++ if genA.step().value % 65536 is genB.step().value % 65536
  pairs
