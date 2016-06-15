conv3d2d = (x, y, z, centre, zoom)-> x: x/z*(zoom||1)+centre.x, y: y/z*(zoom||1)+centre.y
convDeg2d = (l, deg, centre)-> x: (l*Math.cos(deg))+centre.x, y: (l*Math.sin(deg))+centre.y
convAngleDeg = (angle)-> angle * (Math.PI / 180)

{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  cb()
  init:->
    graph = new PIXI.Graphics
    graph.position.x = 0
    graph.position.y = 0
    stage.addChild graph

    cnt = 0

    startAngle = 4
    first = true

    firstBranch = x: W/2, y:H, len: H/10*1.5, angle: startAngle, startAngle: 270+startAngle, lenFactor: 1.25
    lastBranches = [ firstBranch ]


    drawBranch = (oldBranch, first)->
      graph.lineStyle (oldBranch.len/10)+0.1, 0x44aa22*oldBranch.len/10, 1#-cnt/20

      angle1 = oldBranch.startAngle-oldBranch.angle
      branch1 = convDeg2d oldBranch.len, convAngleDeg(angle1), { x:oldBranch.x, y:oldBranch.y }

      graph.moveTo oldBranch.x, oldBranch.y
      graph.lineTo branch1.x, branch1.y

      lastBranches.push
        x:branch1.x
        y:branch1.y
        startAngle:angle1
        angle:oldBranch.angle
        len: (oldBranch.len/oldBranch.lenFactor)
        lenFactor: oldBranch.lenFactor
      if !first
        angle2 = oldBranch.startAngle+oldBranch.angle
        branch2 = convDeg2d oldBranch.len, convAngleDeg(angle2), { x:oldBranch.x, y:oldBranch.y }

        graph.moveTo oldBranch.x, oldBranch.y
        graph.lineTo branch2.x, branch2.y

        lastBranches.push
          x:branch2.x
          y:branch2.y
          startAngle:angle2
          angle:oldBranch.angle
          len: oldBranch.len/oldBranch.lenFactor
          lenFactor: oldBranch.lenFactor



    draw = ->
      # if (cnt++)>8
      #   graph.clear()
      #   first = true
      #   cnt = 0
      graph.clear()
      while (cnt++)<12
        tempBranches = lastBranches
        lastBranches = []
        for branch in tempBranches
          drawBranch branch, first
          first = false

      firstBranch.angle+=.1
      firstBranch.startAngle = 270+firstBranch.angle
      firstBranch.lenFactor -= 0.001
      firstBranch.len = H/10*firstBranch.lenFactor
      lastBranches = [ firstBranch ]
      cnt = 0
      first = true


