items = 
  char   : '☃'
  trophy : '☥'
  trap   : '☠'
  star   : '★'
  wall   : '#'
  rock   : '-'
  floor  : ' '
  
map = """
----# #---------------
----# ##--------------
----# #####-----------
----# s  ##-----------
----#### ##########---
------##         ##---
--###### ######  ####-
--# k    #----#s    #-
--#      #----####  #-
--# #### #-------#  #-
--# ####k#--######  #-
--# #### #--#       #-
--#s     #--# #   # #-
--###  ###--# #   # #-
----#  #----#s#   # #-
----#  #----#k# ### #-
----#  #------# s## #-
-####  ######## ### #-
-#     ########    sk-
-#       s##        #-
-# ######    #### ###-
-# ##---#k#  #--# #---
-# ###----#  #--#k#---
-#  s######  ########-
-#k             w####-
-####################-
"""
.replace('x', items.char)
.replace('w', items.trophy)
.replace(/s/g, items.star)
.replace(/k/g, items.trap)
.split(/\n/g)

lastLine = null
  
Player =
  x: 0
  y: 0
  points: 0
  setPosition: (@x, @y) ->
  move: (direction) ->
    switch direction
      when 'down'
        @trymove @y+1, @x
      when 'left'
        @trymove @y, @x - 1
      when 'right'
        @trymove @y, @x + 1
  trymove: (y, x) ->
    next = map[y]?[x]
    switch next
      when items.trap then throw 'Death'
      when items.trophy then endGame()
      when items.trap then die()
      when items.star then @score(x,y)
      when items.floor then @setPosition(x,y)
  score: (x,y) ->
    @points++
    @setPosition(x,y)
          
endGame = ->
  console.log """
    You found Sanctuary.

    Your score: #{Player.points}
  """
      
draw = (n) ->
  line = (map[Player.y] = map[Player.y].replace(items.char, items.floor)).split('')
  line[Player.x] = items.char
  map[Player.y] = line.join('')
  if map[Player.y] isnt lastLine
    lastLine = map[Player.y]
    console.log lastLine
      
reset = ->
  map = map.map (l) -> l.replace items.char, items.floor
  Player.setPosition 5, 0
  lastLine = null
  intro()
  draw()
  
document.addEventListener 'keydown', (e) ->
  directions = ['left', 'up', 'right', 'down']
  Player.move directions[e.keyCode - 37]
  draw()
, false
  
window.addEventListener 'error', (e) ->
  reset()
, false

document.getElementById('start').addEventListener 'click', reset, false

intro = ->
  console.log """
  \n\n\n\n\n\
  ###########
  # Sandman #
  ###########
  You've managed to escape. There is only one way to go.
  Your own shadow echoes the steps you took along the way.\n
  """

if ~navigator.userAgent.indexOf('WebKit')
  setTimeout intro, 1000
  intro = ->
