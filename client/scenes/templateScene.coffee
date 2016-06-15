{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init: ->
    graph = new PIXI.Graphics
    graph.position.x = W / 2
    graph.position.y = H / 2
    count = 0
    stage.addChild graph

    draw = ->
      graph.clear()
      graph.clear()
      cc = count
      x = (c)-> Math.cos((c)%360)*(W*0.35)
      y = (c)-> Math.sin((c)%360)*(H*0.35)
      spd = 0.5
      spread = (count/20)
      while cc-count<32*spd
        graph.lineStyle 1, ((cc-count)*8)&0xffffff, 1
        graph.beginFill ((cc-count)*0xf)&0xffffff, 0.5
        #console.log x(), y()
        graph.moveTo y(cc/8),x(cc/9)
        graph.bezierCurveTo x(cc/4),y(cc/5), y(cc/6),x(cc/7), y(cc/8),x(cc/9)
        cc+=spd
      count += .125
