fs = require 'fs'
config = require '../../config'
getWaveFrames = require '../helpers/extractWav'
waveFrames = []

module.exports = (stage, W, H, FPS, cb)->
  getWaveFrames (frames)->
    console.log "WaveLoaded", frames
    waveFrames = frames
    cb()
  init: ->
    graph = new PIXI.Graphics
    graph.position.x = 0
    graph.position.y = H/5*4
    graph.scale = x: 1, y: .2
    count = 0
    stage.addChild graph

    draw = ->
      drawFft = ->
        frameState = config.frameState
        return if !waveFrames[0][frameState]?
        fftdata = waveFrames[0][frameState].fft.slice 0, 128
        i = fftdata.length-1
        sizeX = W/i
        graph.clear()
        while i--
          v = fftdata[i].magnitude
          graph.lineStyle 5, 0xff00ff, 1
          graph.drawRect i*sizeX, 0, sizeX, v*2
      drawWaveform = ->
        frameState = config.frameState+8
        return if !waveFrames[0][frameState]?
        wavdata = waveFrames[0][frameState].data
        i = wavdata.length-1
        sizeX = W/i
        graph.clear()
        while i--
          v = wavdata[i]
          graph.lineStyle 5, 0xff00ff, 1
          graph.drawRect i*sizeX, 0, sizeX, H*v
      drawWaveform()
