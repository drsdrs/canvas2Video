spawn = require('child_process').spawn
fps =  require './fps'
recorder = require './recorder'
director = require './director'
renderer = PIXI.autoDetectRenderer W, H, antialias: true
stage = new PIXI.Container
stage.interactive = false
screenplay = require('./screenplay')(stage)
W = 600
H = 430
count = 0


text = new PIXI.Text 'FPS METER', font : '14px Arial', fill : 0xff1010, align : 'center'
text.position.x = 4
text.position.y = 4


document.body.appendChild renderer.view
stage.addChild text

draw = ->
  text.text = fps.getFPS() + "fps -- frames:" + Math.round count*10
  recorder.putFrame director.direct(), ->window.requestAnimationFrame draw
  renderer.render stage

window.onload = ->
  #record.start()
  recorder.canvas = renderer.view
  director.init screenplay
  window.requestAnimationFrame draw
