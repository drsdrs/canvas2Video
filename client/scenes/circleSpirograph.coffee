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
      drawPos = convDeg2d s.getLength(), convAngleDeg(s.getAngle()), {x:W/2, y:H/2}
      graph.beginPath()
      graph.arc drawPos.x, drawPos.y, s.getRadius(), s.getStartAngle(), s.getEndAngle()
      graph.strokeStyle = s.getColor()
      graph.lineWidth = s.getLineWidth()
      graph.stroke()


    spirographs = [
      { # 0
        getLength: -> Math.sin(@lenCnt+=.1)*W/5
        getAngle: -> Math.sin(@angleCnt+=.0005)*180
        getColor: -> rgba2String(255, @getAngle()/2, 0, @getAlpha())
        getLineWidth: -> 1
        getAlpha: -> .5
        getRadius: -> 125
        getStartAngle: -> 0
        getEndAngle: -> 2*Math.PI
        lenCnt: 0
        angleCnt: 0
      },{ # 1
        getLength: -> Math.sin(@lenCnt+=.1)*W/5
        getAngle: ->
          @angleCnt+=.1
        getColor: ->
          l = @getLength()
          rgba2String(l, l, l, @getAlpha())
        getLineWidth: -> 1.5
        getAlpha: -> .25
        getRadius: -> Math.abs Math.sin(@angleCnt+=.00005)*45
        getStartAngle: -> 0
        getEndAngle: -> 2*Math.PI
        lenCnt: 0
        angleCnt: 0
        radiusCnt: 270
      },{ # 2
        getLength: -> Math.sin(@lenCnt+=.01)*W/5
        getAngle: ->
          @angleCnt+=.1
        getColor: ->
          l = @getLength()
          rgba2String(l, 0, 255, @getAlpha())
        getLineWidth: -> 3
        getAlpha: -> .25
        getRadius: -> Math.abs Math.sin(@angleCnt+=.00005)*45
        getStartAngle: -> 0
        getEndAngle: -> 2*Math.PI
        lenCnt: 0
        angleCnt: 0
        radiusCnt: 270
      },{ # 3
        getLength: -> Math.sin(@lenCnt+=.0075)*W/5
        getAngle: ->
          @angleCnt+=360/1000
        getColor: ->
          l = @getLength()
          rgba2String(l, 255, l/3, @getAlpha())
        getLineWidth: -> 1
        getAlpha: -> .5
        getRadius: -> Math.abs @getLength()/8
        getStartAngle: -> 0
        getEndAngle: -> 2*Math.PI
        lenCnt: 0
        angleCnt: 0
        radiusCnt: 270
      },{ # 4
        getLength: -> Math.sin(@lenCnt+=.00075)*W/5
        getAngle: ->
          @angleCnt+=360/1000
        getColor: ->rgba2String(255, 255, 255, @getAlpha())
        getLineWidth: -> 3
        getAlpha: -> .05
        getRadius: -> Math.abs Math.sin(@radiusCnt+=.00075)*64
        getStartAngle: -> 0
        getEndAngle: -> 2*Math.PI
        lenCnt: 0
        angleCnt: 0
        colorCnt: 0
        radiusCnt: 270
      },{ # 5
        getLength: ->
          if @lenCnt>H/2
            @rounds++
            @lenCnt=0
          @lenCnt+=.01
        getAngle: ->
          @angleCnt+=366/1000
        getColor: ->
          col1 = (@radiusCnt)&1
          rgba2String((@rounds&1)*255, (@rounds&1)*255, (@rounds&1)*255, @getAlpha())
        getLineWidth: -> .5
        getAlpha: -> 0.25
        getRadius: -> @getLength()
        getStartAngle: -> @getLength()/10
        getEndAngle: -> (Math.PI)-(@getLength()/10)
        lenCnt: 0
        angleCnt: 0
        cAngleCnt: 0
        colorCnt: 0
        radiusCnt: 270
        rounds: 1
      },{ # 6
        getLength: -> H/4
        getAngle: ->
          if @angleCnt>360
            @angleCnt = 0
            @rounds+=.25
          @angleCnt+=.5111
        getColor: ->
          col1 = (@radiusCnt)&1
          rgba2String((@rounds&1)*255, (@rounds&1)*255, (@rounds&1)*255, @getAlpha())
        getLineWidth: -> 6
        getAlpha: -> 0.05
        getRadius: -> H/4
        getStartAngle: -> (@getLength()/H/4)+@rounds
        getEndAngle: -> (Math.PI)-(@getLength()/H/4)+@rounds
        lenCnt: 0
        angleCnt: 0
        cAngleCnt: 0
        colorCnt: 0
        radiusCnt: 270
        rounds: 1
      }
    ]


    spirographToShow = spirographs.length-2
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
