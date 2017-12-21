input = require './input'
{ assert, time, timeEnd, log } = console

class GPU
  constructor: (input)->
    @particles = (new Particle line for line in input.split '\n')

    # seed the prev diffs
    @prev_diffs ||= @diffs()

    converging = true
    while converging

      # step forward
      @step()

      # find dupes
      dupes = @dupes()

      # remove dupes
      @particles = (p for p in @particles when p.position() not in dupes)

      # gtfo is there's only 1 particle left (special case)
      return @ if @particles.length is 1

      # check if any points are still converging
      converging = @converging()

      # update prev diffs
      @prev_diffs = @diffs()

  ###
    A list of the 'x,y,z' coords
    of any colliding particles
  ###
  dupes: ->
    positions = (p.position() for p in @particles).sort()
    dupes = []
    for pos, i in positions
      if pos is positions[i+1]
        dupes.push pos unless pos in dupes
    dupes

  ###
    create an array of the distances
    between a particle and its next
    neighbour - if these points are
    all get larger with each iteration
    then no particles can collide
  ###
  diffs: ->
    [dx, dy, dz] = [[],[],[]]
    for p, idx in @particles
      if np = @particles[idx+1]
        dx.push Math.abs np.x - p.x
        dy.push Math.abs np.y - p.y
        dz.push Math.abs np.z - p.z
    [dx, dy, dz]

  ###
    checks to see if any points are
    getting closer to their neighbours
  ###
  converging: ->
    for dim, i in @diffs()
      for el, j in dim
        if @prev_diffs[i][j] > el or @prev_diffs[i][j] > el or @prev_diffs[i][j] > el
          return true

  step: ->
    p.step() for p in @particles


class Particle
  constructor: (line)->
    [@x,@y,@z,@vx,@vy,@vz,@ax,@ay,@az] = \
      line
      .match /(-?\d+)/g
      .map (v)->
        parseInt v, 10

  position: ->
    [@x,@y,@z].join ','

  step: ->
    # update velocity
    @vx += @ax
    @vy += @ay
    @vz += @az
    # update position
    @x += @vx
    @y += @vy
    @z += @vz


###
  Answer
###

log (new GPU input).particles.length


###
  Tests
###

input = """
p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
"""

assert 1 is (new GPU input).particles.length
