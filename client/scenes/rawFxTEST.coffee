{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init: ->
    canvasEl = document.createElement 'canvas'
    canvasEl.width = W
    canvasEl.height = H
    textureCanvas = new PIXI.Texture.fromCanvas(canvasEl, 1)
    canvasSprite = new PIXI.Sprite textureCanvas
    canvasSprite.position = x: 0, y: 0
    canvasSprite.scale = x: 1, y: 1
    stage.addChild canvasSprite

    doTask = require('../rawFxs/rawFxs.coffee')(canvasEl, W, H, FPS)


    #for i in [0...300] then doTask 'tron'

    draw = ->
      #doTask "draw", "arc", 2, .05, .1 # Speed ? # rnd1 0-1 # rnd2 0-1

      doTask 'tron'
      # doTask "starfield"
      # doTask "zoom", {x:-.01, -.01}

