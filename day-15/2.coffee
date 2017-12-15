{ assert, time, timeEnd } = console

class Generator
  constructor: (@factor, @value, @round=1)->

  step: (iterations=1)->
    for i in [0...iterations]
      loop
        @value = @value * @factor % 2147483647
        break if @value % @round is 0
    @


###
  Answer
###

console.log do ->
  genA = new Generator 16807, 516, 4
  genB = new Generator 48271, 190, 8

  i = 0
  pairs = 0
  while i++ < 5000000
    pairs++ if genA.step().value % 65536 is genB.step().value % 65536
  pairs


###
  Tests
###

# old tests
assert 1352636452 is new Generator(16807,65).step(5).value
assert 285222916 is new Generator(48271,8921).step(5).value

# new tests
assert 740335192 is new Generator(16807,65,4).step(5).value
assert 412269392 is new Generator(48271,8921,8).step(5).value

# takes ~ 1500 ms
assert 309 is do ->
  # 5 M pair test
  genA = new Generator 16807, 65, 4
  genB = new Generator 48271, 8921, 8

  i = 0
  pairs = 0
  while i++ < 5000000
    pairs++ if genA.step().value % 65536 is genB.step().value % 65536
  pairs
