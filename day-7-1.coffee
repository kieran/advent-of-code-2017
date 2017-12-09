assert = console.assert
input = require './day-7-input.coffee'

pat = /(\S+)\s\((\d+)\)(\s->\s(.*))?/

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

  base: ->
    for name, disc of @discs
      return disc if disc.parent is null

class Disc
  constructor: (@name, @weight)->
    @parent = null

###
  Answer
###

tower = new Tower input
console.log tower.base().name


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
