assert = console.assert
input = require './day-7-input.coffee'

pat = /(\S+)\s\((\d+)\)(\s->\s(.*))?/

sum = (arr)-> arr.reduce (m, el)->
  m += el
, 0

mean = (arr)->
  arr
  .sort (a,b)->
    (v for v in arr when v is a).length -
    (v for v in arr when v is b).length
  .pop()

uniq = (arr)->
  ret = []
  ret.push a for a in arr when a not in ret
  ret


class Tower
  constructor: (input)->
    @discs = {}

    # collect base discs
    for line in input.split /\n/
      [match, name, weight, ..., children] = line.match pat
      @discs[name] = new Disc(name, parseInt weight)

    # resolve parents
    for line in input.split /\n/
      [match, name, weight, ..., children] = line.match pat
      continue unless children
      for child in children.split ", "
        @discs[child].parent = @discs[name]
        @discs[name].children.push @discs[child]

  base: ->
    for name, disc of @discs
      return disc if disc.parent is null

class Disc
  constructor: (@name, @weight)->
    @parent = null
    @children = []

  # return null if weight matches
  # otherwise return target self-weight
  # (recursive)
  assertWeight: (tw)->
    # assert self-weight
    if tw?
      unless tw is @totalWeight()
        # only fix at this depth if the subtree is balanced
        if @balanced()
          return tw - @weightOfChildren()
        # otherwise continue down the tree

    # recursively assert child weights
    for c in @children
      return w if w = c.assertWeight @correctWeight()

  # the total weight of this tree
  totalWeight: ->
    @weight + @weightOfChildren()

  # the total weight of children only (recursive)
  weightOfChildren: ->
    sum @childWeights()

  childWeights: ->
    (c.totalWeight() for c in @children)

  # the most common child weight
  correctWeight: ->
    mean @childWeights()

  # is this subtree balanced?
  # true if all child weights are the same
  balanced: ->
    1 is uniq(@childWeights()).length



###
  Answer
###

tower = new Tower input
console.log tower.base().assertWeight()


###
  Tests
###

input = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

tower = new Tower input
assert 'tknk' is tower.base().name
assert 60 is tower.base().assertWeight()

assert 15 is sum [ 1, 2, 3, 4, 5 ]
assert 3 is mean [ 3, 4, 3, 3, 5 ]
assert 2 is uniq([ 1, 2, 1, 1, 2 ]).length
