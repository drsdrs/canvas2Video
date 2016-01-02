{ FPS, W, H } = require '../config'
scenes = null

module.exports = (stage, cb)->
  superCb = (scenes)-> cb(screenplay scenes)
  require('./getScenes') stage, superCb

screenplay = (scenes)->
  [{
    time: 0, loop: true
    init: ->
      do1 = scenes.get("audioAnalysis")()
      do2 = scenes.get('beatTrigger')(173)
      draw = ->
        do1()
        do2()
  }, {
    time: 30, loop: true
    init: scenes.get "walkingKiwi"
  }, {
    time: 32, loop: true
    init: ->
      i = 0
      tunnel = scenes.get("tunnel")()
      play = -> tunnel Math.cos(i/80)*20, 1+Math.sin(++i/65)*20, 32, i*i>>8
  }, {
    time: 40, end: true, loop: false
    init: ->
      console.log "EndInit  4"
      draw = -> console.log "Enddraw  4"
  }]
