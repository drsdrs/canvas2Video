{ FPS, W, H } = require '../config'
renderer = PIXI.autoDetectRenderer W, H, antialias: true, true
stage = new PIXI.Container
fps =  require './helpers/fps'
recorder = require './recorder'
director = require './director'
{measure} = require './helpers/measure'
frames = 0
text = document.createElement 'span'

draw = ->
  if recorder.recording||true then render()
  else # correct fps to actual FPS only if not recording
    rate = 1000/FPS
    diff = 1000/(fps.fpsAvg||FPS)
    setTimeout render, rate-((diff-rate)*3)

render = ->
  next = ->
    window.requestAnimationFrame draw
    fps.getFps()
    text.innerHTML = fps.fps + "fps - frames:" + frames
    renderer.render stage
    frames++

  if !director.direct() then return recorder.stop(); console.log "STOPSTOPSTOP Should not happen!!!!!!!!!!!!!!!!!!"
  if recorder.recording
    text.style.color = "#f24"
    recorder.putFrame renderer.view.toDataURL(), -> next()
  else
    text.style.color = "#fff"
    next()

window.onload = ->
  require('./screenplay')(stage, startApp)

startApp = (screenplay)->
  appEl = document.getElementById 'app'

  appEl.appendChild renderer.view
  appEl.appendChild text

  director.init screenplay, FPS
  recorder.init renderer.view, FPS
  #if confirm("Record ?") then recorder.start()
  #recorder.start()
  window.requestAnimationFrame draw
