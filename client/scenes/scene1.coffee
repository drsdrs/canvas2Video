module.exports = (stage, W, H, FPS, cb)->
  cb()
  init:->
    graph = new PIXI.Graphics
    graph.position.x = 620 / 2
    graph.position.y = 380 / 2
    count = 0
    stage.addChild graph

    draw = ->
      graph.clear()
      count += 0.1
      graph.clear()
      graph.lineStyle 10, 0xff0000, 1
      graph.beginFill 0xffFF00, 0.5
      graph.moveTo -120 + Math.sin(count) * 20, -100 + Math.cos(count) * 20
      graph.lineTo 120 + Math.cos(count) * 20, -100 + Math.sin(count) * 20
      graph.lineTo 120 + Math.sin(count) * 20, 100 + Math.cos(count) * 20
      graph.lineTo -120 + Math.cos(count) * 20, 100 + Math.sin(count) * 20
      graph.lineTo -120 + Math.sin(count) * 20, -100 + Math.cos(count) * 20
      graph.rotation = count * 0.1
