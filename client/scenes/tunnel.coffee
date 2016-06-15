{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init: ->
    graph = new PIXI.Graphics
    graph.position.x = 0
    graph.position.y = 0
    stage.addChild graph

    draw = (spdX, spdY, steps, endSize)->
      graph.clear()
      spdX = spdX||0
      spdY = spdY||0
      steps = steps||32
      endSize = endSize||W/10
      step = 0
      stepSizeX = (W-endSize)/steps
      stepSizeY = (H-endSize)/steps
      strokeStep = 255/steps
      while step<steps
        rx = ((W/2-endSize/2)-((stepSizeX-(spdX*(steps-step-1)/steps))*step/2))
        ry = ((H/2-endSize/2)-((stepSizeY-(spdY*(steps-step-1)/steps))*step/2))
        rw = endSize+stepSizeX*step
        rh = endSize+stepSizeY*step
        graph.lineStyle 2, 0x88aaee, 1
        graph.drawRect rx, ry, rw, rh
        step++
