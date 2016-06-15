{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init:->
    graph = new PIXI.Graphics
    graph.position.x = W
    graph.position.y = H
    stage.addChild graph

    entities:
      zombies: []
      humans: []
      walls: []

    zombies = 64
    humans = 64
    walls = 64

    while zombies--
      x = w/2
      y = h/2
      while checkSight(x, y)==false
        x = Math.floor Math.random()*W
        y = Math.floor Math.random()*H
      zombies.push {
      }

    checkSight = (x,y)->
      sight = 20
      for v,i in entities.zombies then if compare(x, y, v.x, v.y, sight)==false then return false
      for v,i in entities.humans then if compare(x, y, v.x, v.y, sight)==false then return false
      for v,i in entities.walls then if compare(x, y, v.x, v.y, sight)==false then return false

    compare = (x1, y1, x2, y2, sight)->
      if x1+sight>x2||x1-sight<x2 then true
      else if y1+sight>y2||y1-sight<y2 then true
      else false

    draw = ->
      graph.clear()

      graph.rotation = count * 0.1
