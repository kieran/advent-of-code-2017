assert = console.assert
input = require './input'

class Firewall
  constructor: (@layers={})->

  @parse: (input)->
    firewall = new @
    for line in input.split '\n'
      layer = Layer.parse line
      firewall.layers[layer.depth] = layer
    firewall

  severity: ->
    score = 0
    for depth, layer of @layers
      score += layer.severity if layer.caught()
    score


class Layer
  constructor: (@depth, @range)->
    @period = @range * 2 - 2
    @severity = @range * @depth

  @parse: (input)->
    [depth, range] = input.match /(\d+)/g
    new @ parseInt(depth), parseInt(range)

  caught: ->
    0 is @depth % @period


###
  Answer
###

console.log Firewall.parse(input).severity()


###
  Tests
###

input = """
0: 3
1: 2
4: 4
6: 4
"""

assert 24 is Firewall.parse(input).severity()
