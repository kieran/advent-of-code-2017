###

  I abandoned this approach
  because it was oddly slow

  40 M generations took about 7 seconds
  whereas the class-based approach clocked
  in at about 1.6 seconds

  This feels.... wrong. But whatever.

###

{ assert, time, timeEnd } = console

generator = (factor, value)->
  loop
    yield value = value * factor % 2147483647
  return

###
  Answer
###

console.log do ->
  # 40 M pair test
  genA = generator 16807, 516
  genB = generator 48271, 190

  i = 0
  pairs = 0
  while i++ < 40000000
    pairs++ if genA.next().value % 65536 is genB.next().value % 65536
  pairs


###
  Tests
###

assert 1352636452 is do ->
  gen = generator 16807, 65
  val = gen.next().value for i in [0...5]
  val

assert 285222916 is do ->
  gen = generator 48271, 8921
  val = gen.next().value for i in [0...5]
  val

#takes ~ 1600 ms
assert 588 is do ->
  # 40 M pair test
  genA = generator 16807, 65
  genB = generator 48271, 8921

  i = 0
  pairs = 0
  while i++ < 40000000
    pairs++ if genA.next().value % 65536 is genB.next().value % 65536
  pairs

