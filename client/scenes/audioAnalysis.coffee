fs = require 'fs'
config = require '../../config'
getWaveFrames = require '../helpers/checkCachedAudioFile'
ah = require '../helpers/arrayHelpers'
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
    Group = new PIXI.Container()
    Group.addChild graph

    shadow = new PIXI.filters.GrayFilter()


    blur = new PIXI.filters.BlurFilter()
    blur.blur = 16
    stage.filters = [shadow,blur]

    stage.addChild graph

    cnt = 0

    draw = ->
      graph.clear()
      drawFft = ->
        frameState = config.frameState
        frameL = waveFrames[0][frameState]
        frameR = waveFrames[1]?[frameState]
        return false if !frameL?
        fftdataL = frameL.fft.magn.slice 4, frameL.fft.magn.length
        fftdataR = frameR.fft.magn.slice 4, frameR.fft.magn.length
        i = fftdataR.length-1
        sizeX = 45*6/i
        while i--
          vR = fftdataR[i]
          vL = fftdataL[i]
          graph.lineStyle 2, 0xaa88ee, 0.8
          graph.beginFill 0xeeaa88
          graph.drawRect i*sizeX+(W-45*6), H, sizeX, -Math.log(vL)*16
          graph.drawRect i*sizeX+(W-45*6), 0, sizeX, Math.log(vR)*16
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
      fftRing = ->
        frame = waveFrames[0][config.frameState]
        return false if !frame?
        fftdata = frame.fft.magn.slice 16, frame.fft.magn.length/2
        fftdata = ah.simplifyArray fftdata, 8
        fftdata = ah.smoothArray fftdata
        pos = {x:(W-45*6), y:H/2}
        WH = if W>H then W else H
        size = WH / fftdata.length
        for v,i in fftdata
          graph.lineStyle 4, 0x88eeaa, 1-Math.log(v)
          graph.drawCircle pos.x, pos.y, (size*i)+v/WH*256
      #drawWaveform()
      fftRing()
      drawFft()
