{W, H, FPS, BPM} = require '../../config'
conf = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init: ()->
    bps = BPM/60
    graph = new PIXI.Graphics
    text = new PIXI.Text 'This is a pixi text', font : '48px Arial', fill : 0x88aaee, align : 'left', stroke: 0x444444
    text.position =  x: 5, y:5
    text.anchor.set(0, 0);
    graph.position = x:0, y:0
    graph.fill = 0xff0000
    graph.drawRect W/3, H/3, W/3, H/3
    stage.addChild graph
    stage.addChild text

    draw = ()->
      graph.clear()
      beat = conf.frameState/FPS*bps
      bc = 255^((((beat/16)%1)*(255))&255)
      bb = [ (bc>>7)&1, (bc>>6)&1, (bc>>5)&1, (bc>>4)&1, (bc>>3)&1, (bc>>2)&1, (bc>>1)&1, (bc>>0)&1 ]
      text.text = Math.floor(beat/4)+':'+Math.floor(((beat/4)%1)*10/2.5).toFixed(0)


      for v,i in bb then if i<6
        col = if !bb[i] then 0xffffff else 0xaa88ee
        graph.beginFill col
        graph.lineStyle 1, 0, 1
        graph.drawRect W-45*8-45*(6-i), 5, 40, 40


