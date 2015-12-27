W = 800
H = 600
FPS = 24
renderer = PIXI.autoDetectRenderer W, H, antialias: true, true
stage = new PIXI.Container
fps =  require './fps'
recorder = require './recorder'
director = require './director'
screenplay = require('./screenplay')(stage, renderer, W, H)
frames = 0
text = document.createElement 'span'
measure = require('./MeasureTime')()

draw = ->
  if !director.direct() then return recorder.stop(); console.log "STOPSTOPSTOP"
  if recorder.recording
    text.style.color = "#f24"
    recorder.putFrame renderer.view.toDataURL(), ->
      window.requestAnimationFrame draw
  else
    text.style.color = "#fff"
    window.requestAnimationFrame draw
  fps.getFPS()
  text.innerHTML = fps.fpsAvg + "fps - frames:" + frames
  renderer.render stage
  frames++

window.onload = ->
  appEl = document.getElementById 'app'

  appEl.appendChild renderer.view
  appEl.appendChild text

  director.init screenplay
  recorder.init renderer.view, FPS
  #if confirm("Record ?") then recorder.start()
  window.requestAnimationFrame draw
