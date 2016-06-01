{ FPS, W, H, BPM } = require '../config'
scenes = null

module.exports = (stage, cb)->
  superCb = (scenes)-> cb(screenplay scenes)
  require('./getScenes') stage, superCb

screenplay = (scenes)->
  [{
    time: 0, loop: true
    init: ->
      i = 0
      do1 = scenes.get("audioAnalysis")()
      do2 = scenes.get('beatTrigger')(BPM)
      draw = ->
        #tunnel Math.cos(i/80)*20, 1+Math.sin(++i/65)*20, 32, i*i>>8
        do1()
        do2()
  }, {
    time: 0, loop: true
    init: scenes.get "walkingKiwi"
  }, {
    time: 0, loop: true
    init: ->
      i = 0
      tunnel = scenes.get("tunnel")()
      play = ->
        do1()
        #do2()
        tunnel Math.cos(i/80)*20, 1+Math.sin(++i/65)*20, 32, i*i>>8
  }, {
    time: 3, loop: true
    init: scenes.get "scene1"
  }, {
    time: 20, loop: true
    init: scenes.get "walkingKiwi"
  }, {
    time: 40, loop: true
    init: ->
      i = 0
      #tunnel = scenes.get("tunnel")()
      play = ->
        do1()
        #do2()
        #tunnel Math.cos(i/80)*20, 1+Math.sin(++i/65)*20, 32, i*i>>8
  }, {
    time: 45, end: true, loop: false
    init: ->
      draw = -> console.log "End SCENE"
  }]
