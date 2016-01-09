fs = require 'fs'
config = require '../../config'
getWaveFrames = require '../helpers/checkCachedAudioFile'
ah = require '../helpers/arrayHelpers'
fftH = require '../helpers/fftHelpers'
waveFrames = []

module.exports = (stage, W, H, FPS, cb)->
  getWaveFrames (frames)->
    console.log "WaveLoaded", frames
    waveFrames = frames
    cb()
  init: ->
    graph = new PIXI.Graphics
    graph.position.x = 0
    graph.position.y = 0
    graph.scale = x: 1, y: 1
    count = 0
    stage.addChild graph

    draw = ->
      drawFft = ->
        frameState = config.frameState
        frameL = waveFrames[0][frameState]
        frameR = waveFrames[1]?[frameState]
        return false if !frameL?
        fftdataL = frameL.fft.magn.slice 8, frameL.fft.magn.length
        fftdataR = frameR.fft.magn.slice 8, frameR.fft.magn.length
        fftdataL = ah.simplifyArray fftdataL, 8
        fftdataR = ah.simplifyArray fftdataR, 8
        i = fftdataR.length-1
        sizeX = W/i
        while i--
          vR = fftdataR[i]
          vL = fftdataL[i]
          graph.lineStyle 1, 0xffffff, 1
          graph.beginFill 0x00ff00
          graph.drawRect i*sizeX, H/2, sizeX, vR/64
          graph.drawRect i*sizeX, H/2, sizeX, -vL/64
      drawWaveform = ->
        frameState = config.frameState
        return if !waveFrames[0][frameState]?
        wavdataR = waveFrames[0][frameState].raw
        wavdataL = waveFrames[1][frameState].raw
        i = wavdataR.length-1
        sizeX = W/i
        while i--
          vR = wavdataR[i]
          vL = wavdataL[i]
          graph.lineStyle 1, vR*0xff0ff0, .6
          graph.drawRect i*sizeX, H/2, sizeX, (H/2)*((vR/128)-1)
          graph.lineStyle 1, vL*0x0ffff0, .1
          graph.drawRect i*sizeX, H/2, sizeX, (H/2)*((vL/128)-1)
      graph.clear()
      #drawWaveform()
      #drawFft()
      frame = waveFrames[0][config.frameState]
      return false if !frame?
      fftdata = frame.fft.magn.slice 8, 196
      fftdata = ah.simplifyArray fftdata, 8
      fftH.drawCircleRing fftdata, {x:W/2, y:H/2}, graph
