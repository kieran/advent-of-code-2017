input = require './input'
{ assert, time, timeEnd, log } = console

class GPU
  constructor: (input)->
    @particles = (new Particle line for line in input.split '\n')

  ###
    We only need to care about
    the particle with the lowest
    acceleration, since it will be
    closest to any point in the
    long run.
  ###
  closest: ->
    accels = @particles.map (p)-> p.acceleration()
    accels.indexOf Math.min accels...


class Particle
  constructor: (line)->
    [@x,@y,@z,@vx,@vy,@vz,@ax,@ay,@az] = \
      line
      .match /(-?\d+)/g
      .map (v)->
        parseInt v, 10

  ###
    Calculates the net
    acceleration of all 3 axis
  ###
  acceleration: ->
    [@ax,@ay,@az]
    .map Math.abs
    .reduce (memo, val)->
      memo + val
    , 0


###
  Answer
###

log (new GPU input).closest()


###
  Tests
###

input = """
p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>
"""

assert 0 is (new GPU input).closest()
