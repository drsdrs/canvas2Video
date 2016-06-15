conv3d2d = (x, y, z, centre, zoom)-> x: x/z*(zoom||1)+centre.x, y: y/z*(zoom||1)+centre.y
convDeg2d = (l, deg, centre)-> x: (l*Math.cos(deg))+centre.x, y: (l*Math.sin(deg))+centre.y
convAngleDeg = (angle)-> angle * (Math.PI / 180)
rgba2String = (r,g,b,a)-> 'rgba('+(r&255)+','+(g&255)+','+(b&255)+','+a+')'


{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init:->
    canvasEl = document.createElement 'canvas'
    canvasEl.width = W
    canvasEl.height = H
    graph = canvasEl.getContext "2d"
    textureCanvas = new PIXI.Texture.fromCanvas canvasEl

    count = 0
    canvasSprite = new PIXI.Sprite textureCanvas
    canvasSprite.position = x: 0, y: 0
    canvasSprite.scale = x: 1, y: 1
    stage.addChild canvasSprite


    drawSpiro = ()->
      drawPos = convDeg2d @length, convAngleDeg(@angle), @centerPos
      if @lastDrawPos?
        graph.beginPath()
        graph.moveTo @lastDrawPos.x, @lastDrawPos.y
        graph.lineTo drawPos.x, drawPos.y
        graph.strokeStyle = @getColor()
        graph.lineWidth = @getLineWidth()
        graph.stroke()
        @angle += @rotationDir*@rotationSpeed
        @lengthMod()
      @lastDrawPos = drawPos

    spirographs = [
      { #0
        centerPos: x:W/2, y:H/2
        rotationDir: -1
        rotationSpeed: 6
        angle: 270
        length: 1
        i: 0
        lengthMod: -> @length += (Math.sin(@i+=.1))*W/32
        getColor: -> rgba2String(255, @i, @i/10, @getAlpha())
        getLineWidth: -> 3
        getAlpha: -> 0.25
        drawSpiro: drawSpiro
      }, { # 1
        centerPos: x:W/2, y:H/2
        rotationDir: 1
        rotationSpeed: 188+45
        angle: 264
        length: 0.1
        i: 0
        lengthMod: ()-> @length += 16
        getColor: -> rgba2String(255, 255, 255, @getAlpha())
        getAlpha: -> 0.1
        getLineWidth: -> 3
        drawSpiro: drawSpiro
      }, { # 2
        centerPos: x:W/2, y:H/2
        rotationDir: 1
        rotationSpeed: 92
        angle: 270
        length: 0
        i: 0
        lengthMod: ()-> @length = (Math.sin(@i+=0.005))*H/2.01
        getColor: -> 'rgba(255,255,0,0.1)'#rgb2Number(0, @i*32, 128)
        getLineWidth: -> 2
        getAlpha: -> 0.5
        drawSpiro: drawSpiro
      }, { # 3
        centerPos: x:W/2, y:H/2
        rotationDir: 1
        rotationSpeed: 5
        angle: 270
        length: 0
        i: 0
        lengthMod: ()->
          @length = (Math.sin(@i+=0.0005))*H/2.01
          @rotationSpeed += 0.1
        getColor: -> rgba2String 255, (@i*10&1)*255, (@i&4)*64, @getAlpha()
        getLineWidth: -> 1
        getAlpha: -> 0.5
        drawSpiro: drawSpiro
      }, { # 4
        centerPos: x:W/2, y:H/2
        rotationDir: 1
        rotationSpeed: 180
        angle: 270
        length: 1
        i: 1000
        lengthMod: ()->
          @length = (Math.sin(@i+=0.0005))*H/2.01
          @rotationSpeed += 45.000001/2
        getColor: -> rgba2String (@i*6&1)*255, (@i*6&1)*255, (@i*6&1)*255, @getAlpha()
        getLineWidth: -> @length/80
        getAlpha: -> 0.5
        drawSpiro: drawSpiro
      }, { # 5
        centerPos: x:W/2, y:H/2
        rotationDir: 1
        rotationSpeed: .1
        angle: 270
        length: 1
        i: 0
        lengthMod: ()->
          @length = (Math.tan(@i+=0.05))*H/16
          @rotationSpeed = Math.sin(@i)*360
        getColor: -> rgba2String 0, @i, @i, @getAlpha()
        getLineWidth: -> 4
        getAlpha: -> 0.5
        drawSpiro: drawSpiro
      }, { # 6
        centerPos: x:W/2, y:H/2
        rotationDir: -1
        rotationSpeed: .25
        angle: 270
        length: (Math.cos(@i+=0.005))*H/2
        i: 0
        lengthMod: ()->
          @length = ((Math.cos(@i+=0.005))*H/4)+(Math.sin(@i/2)*H/4)
        getColor: -> rgba2String 128, 128, 255, @getAlpha()
        getLineWidth: -> 3
        getAlpha: -> 0.8
        drawSpiro: drawSpiro
      }, { # 7
        centerPos: x:W/2, y:H/2
        rotationDir: -1
        rotationSpeed: .175
        angle: 270
        length: (Math.cos(@i+=0.005))*H/2
        i: 0
        lengthMod: ()->
          @length = ((Math.cos(@i+=0.00125))*H/3)-(Math.cos(@i/128)*H/8)
        getColor: -> rgba2String 255, 128, 64, @getAlpha()
        getLineWidth: -> 3
        getAlpha: -> 0.5
        drawSpiro: drawSpiro
      }
    ]


    spirographToShow = 0
    spirographCnt = 0

    render = ->
      for spiro in spirographs
        spiro = spirographs[spirographToShow]
        spiro.drawSpiro()
        spiro.length %= W


    returnFunct = ->
      renderCnt = 1
      while renderCnt--
        render()
      if (spirographCnt++)>1000
        spirographCnt = 0
        spirographToShow = (++spirographToShow)%(spirographs.length-1)
        graph.fillStyle = "#000000";
        graph.fillRect 0,0,W,H

