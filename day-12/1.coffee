assert = console.assert
input = require './input'

class Village
  constructor: (@people={})->

  @parse: (input)->
    v = new @
    for line in input.split '\n'
      p = Person.parse line
      v.people[p.id] = p
    v

  #
  # Collect the ids of everyone in the hood
  # (recursive)
  #
  hood: (id, seen=[])->
    seen.push id
    p = @people[id]
    for pid in p.neighbour_ids when pid not in seen
      @hood pid, seen
    seen


class Person
  constructor: (@id, @neighbour_ids)->

  @parse: (input)->
    [id, nids...] = input.match /(\d+)/g
    new @ parseInt(id), (parseInt i for i in nids)


###
  Answer
###

console.log Village.parse(input).hood(0).length


###
  Tests
###

input = """
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
"""

assert 6 is Village.parse(input).hood(0).length
