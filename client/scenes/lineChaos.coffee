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


    drawSpiro = (s)->
      graph.beginPath()
      graph.moveTo s.getX1(), s.getY1()
      graph.lineTo s.getX2(), s.getY2()
      graph.strokeStyle = s.getColor()
      graph.lineWidth = s.getLineWidth()
      graph.stroke()


    spirographs = [
      { # 0
        getX1: -> W/2+(Math.sin(@x1Cnt+=.0011)*W/2)
        getY1: -> H/2+(Math.cos(@y1Cnt+=.0051)*H/2)
        getX2: -> W/2+(Math.sin(@x2Cnt+=.0023)*W/2)
        getY2: -> H/2+(Math.cos(@y2Cnt+=.041)*H/2)
        getColor: -> rgba2String(255, 196, 32, @getAlpha())
        getLineWidth: -> 2
        getAlpha: -> .15
        x1Cnt: 0
        y1Cnt: 0
        x2Cnt: 0
        y2Cnt: 0
      },{ # 1
        getX1: -> W/2+(Math.sin(@x1Cnt+=.005)*W/2)
        getY1: -> H/2+(Math.sin(@y1Cnt+=.0055)*H/2)
        getX2: -> W/2+(Math.sin(@x2Cnt+=.0060)*W/2)
        getY2: -> H/2+(Math.sin(@y2Cnt+=.0065)*H/2)
        getColor: -> rgba2String(196, 255, 32, @getAlpha())
        getLineWidth: -> 2
        getAlpha: -> .15
        x1Cnt: 0
        y1Cnt: 0
        x2Cnt: 0
        y2Cnt: 0
      },{ # 2
        getX1: -> W/2+(Math.sin(@x1Cnt+=.08)*W/2)
        getY1: -> H/2+(Math.sin(@y1Cnt+=.02)*H/2)
        getX2: -> W/2+(Math.sin(@x2Cnt+=.04)*W/2)
        getY2: -> H/2+(Math.sin(@y2Cnt+=.01)*H/2)
        getColor: -> rgba2String(0, 196, 32, @getAlpha())
        getLineWidth: -> 1
        getAlpha: -> .15
        x1Cnt: 0
        y1Cnt: 0
        x2Cnt: 0
        y2Cnt: 0
      },{ # 3
        getX1: -> W/2+(Math.sin(@x1Cnt+=.012)*W/2)
        getY1: -> H/2+(Math.sin(@y1Cnt+=.021)*H/2)
        getX2: -> W/2+(Math.sin(@x2Cnt+=.022)*W/2)
        getY2: -> H/2+(Math.sin(@y2Cnt+=.011)*H/2)
        getColor: -> rgba2String(0, 196, 32, @getAlpha())
        getLineWidth: -> 1
        getAlpha: -> .15
        x1Cnt: 0
        y1Cnt: 0
        x2Cnt: 0
        y2Cnt: 0
      }
    ]


    spirographToShow = spirographs.length-1
    spirographCnt = 0

    render = ->
      for spiro in spirographs
        spiro = spirographs[spirographToShow]
        drawSpiro(spiro)
        spiro.length %= W


    returnFunct = ->
      renderCnt = 1
      while renderCnt--
        render()
      if (spirographCnt++)>100000
        spirographCnt = 0
        spirographToShow = (++spirographToShow)%(spirographs.length-1)
        graph.fillStyle = "#000000"
        graph.fillRect 0, 0, W, H
