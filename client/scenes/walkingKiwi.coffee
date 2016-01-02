module.exports = (stage, W, H, FPS, cb)->
  cb()
  init: ->
    i=0
    partContainer = new PIXI.Container
    headContainer = new PIXI.Container
    headContainer.startRotation = 0
    headContainer.pivot = x: 0, y: -250
    headContainer.position = x: 0, y: -270

    partContainer.position = x: -150, y: H-250
    partContainer.scale = x:.4, y: .4
    partContainer.reverse = 0

    stage.addChild partContainer

    parts =
      body:
        src: 'body.png'
        position: x:0, y:0
        scale: x:1, y:1
        anchor: x:.5, y:.5
        rotation: 1.6
      nose:
        src: 'nose.png'
        position: x:120, y:-380
        scale: x:1, y:1
        anchor: x:0, y:0
        rotation: .5
      head:
        src: 'head.png'
        position: x:0, y:-250
        scale: x:2, y:2
        anchor: x:0.2, y:0.5
        rotation: 2.5
      eye:
        src: 'eye.png'
        position: x:20, y:-280
        scale: x:.5, y:.5
        anchor: x:0.5, y:0.5
        rotation: .5
      legL:
        src: 'leg1.png'
        position: x:50, y:120
        scale: x:1, y:1
        anchor: x:0, y:1
        rotation: 1.6
      legR:
        src: 'leg1.png'
        position: x:-50, y:120
        scale: x:-1, y:1
        anchor: x:0, y:1
        rotation: -1.6
      hand:
        src: 'leg2.png'
        position: x:-10, y:-120
        scale: x:.6, y:.6
        anchor: x:.5, y:1
        rotation: 3.2
    for name, part of parts
      texture = PIXI.Texture.fromImage __dirname+'/assets/'+part.src
      sprite = new PIXI.Sprite texture
      sprite.anchor = part.anchor
      sprite.position = part.position
      sprite.rotation = part.rotation
      sprite.scale = part.scale
      parts[name] = sprite
      parts[name].startRotation = part.rotation
      if name=='head' || name=='nose' || name=='eye'
        headContainer.addChild sprite
      else partContainer.addChild sprite

    partContainer.addChild headContainer


    draw = ->
      runSpd = 25-i/100
      headContainer.rotation = headContainer.startRotation + (Math.sin i/40)/8
      partContainer.position.x += ((Math.abs Math.sin i/runSpd))+60/runSpd
      if partContainer.position.x>W+200 then partContainer.position.x = -150
      legLSin = (Math.sin i/runSpd+1)/3
      legRSin = (Math.sin i/runSpd-1)/4
      partContainer.position.y = 250+(legLSin+legRSin)*130
      parts['hand'].rotation = parts['hand'].startRotation + (Math.sin i/17)/8
      parts['legR'].rotation = parts['legR'].startRotation + legLSin
      parts['legL'].rotation = parts['legL'].startRotation + legRSin
      i++
