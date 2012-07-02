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
-####  ####--## ### #-
-#       s         sk-
-# ####k#### ########-
-# ######### #--------
-#  s##   ## ########-
-#k                w#-
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
    You found sanctuary.

    Your score: #{Player.points}
    Press R to play again.
  """
      
draw = (n) ->
  line = (map[Player.y] = map[Player.y].replace(items.char, items.floor)).split('')
  line[Player.x] = items.char
  map[Player.y] = line.join('')
  if map[Player.y] isnt lastLine
    lastLine = map[Player.y]
    console.log lastLine
      
do reset = ->
  console.clear?()
  map = map.map (l) -> l.replace items.char, items.floor
  Player.setPosition 5, 0
  lastLine = null
  
document.addEventListener 'keydown', (e) ->
  return reset() if e.keyCode is 82
  directions = ['left', 'up', 'right', 'down']
  Player.move directions[e.keyCode - 37]
  draw()
, false
  
window.addEventListener 'error', (e) ->
  reset()
, false
