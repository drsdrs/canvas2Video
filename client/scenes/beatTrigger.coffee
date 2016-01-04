module.exports = (stage, W, H, FPS, cb)->
  cb()
  init: (bpm)->
    bps = bpm/60
    frame = 0
    graph = new PIXI.Graphics
    text = new PIXI.Text 'This is a pixi text', font : '48px Arial', fill : 0xff1010, align : 'center'
    text.position =  x:(W/2), y:H/5*4
    graph.position = x:0, y:0
    graph.fill = 0xff0000
    graph.drawRect W/3, H/3, W/3, H/3
    stage.addChild graph
    stage.addChild text

    draw = ()->
      graph.clear()
      beat = frame/FPS*bps
      bc = 255^((((beat/16)%1)*(255))&255)
      bb = [ (bc>>7)&1, (bc>>6)&1, (bc>>5)&1, (bc>>4)&1, (bc>>3)&1, (bc>>2)&1, (bc>>1)&1, (bc>>0)&1 ]
      text.text = beat/4
      #console.log bb
      if bb[3] # 1
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x88aaee, 1
        graph.drawRect W/4*0, H/5*2, W/4, H/5
      if bb[2] # 2
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x88aaee, 1
        graph.drawRect W/4*1, H/5*2, W/4, H/5
      if bb[1] # 4
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x88aaee, 1
        graph.drawRect W/4*2, H/5*2, W/4, H/5
      if bb[0] # 8
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x88aaee, 1
        graph.drawRect W/4*3, H/5*2, W/4, H/5
      if bb[4] # 1/2
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x88aaee, 1
        graph.drawRect W/4*0, H/5, W/5, H/5
      if bb[5] # 1/4
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0xff0000, 1
        graph.drawRect W/4*1, H/5, W/5, H/5
      if bb[6] # 1/8
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0xffff00, 1
        graph.drawRect W/4*2, H/5, W/5, H/5
      if bb[7] # 1/16
        #graph.fillStyle 0xff0000
        graph.lineStyle 3, 0x00ffff, 1
        graph.drawRect W/4*3, H/5, W/5, H/5
      frame++
