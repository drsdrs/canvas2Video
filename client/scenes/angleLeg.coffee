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

    angleMod = 45
    angleModDir = 15

    firstBranch = x: W/2, y:H/2, len: 5, angle: 22, lenFactor: 1.25
    lastBranches = [ firstBranch ]

    graph.lineStyle 3, 0xffffff, .25

    drawBranch = (oldBranch, branches, lenFactor)->
      BRANCHES = branches
      while branches--
        angle = oldBranch.angle - angleMod
        branchEnd = convDeg2d oldBranch.len, convAngleDeg(angle), oldBranch


        graph.moveTo oldBranch.x, oldBranch.y
        graph.lineTo branchEnd.x, branchEnd.y

        if branchEnd.y < 0 then branchEnd.y = H
        else if branchEnd.y > H then branchEnd.y = 0

        if oldBranch.y < 0 then oldBranch.y = H
        else if oldBranch.y > H then oldBranch.y = 0

        if branchEnd.x < 0 then branchEnd.x = W
        else if branchEnd.x > W then branchEnd.x = 0

        if oldBranch.x < 0 then oldBranch.x = W
        else if oldBranch.x > W then oldBranch.x = 0


        branchEnd.x = (Math.abs branchEnd.x)
        oldBranch.x = (Math.abs oldBranch.x)

        lastBranches.push
          x:branchEnd.x
          y:branchEnd.y
          angle:angle
          len: oldBranch.len/(lenFactor||oldBranch.lenFactor)
          lenFactor: lenFactor||oldBranch.lenFactor



    render = ->
      tempBranches = lastBranches
      lastBranches = []

      for branch in tempBranches
        drawBranch branch, 1, 0.999

      angleMod += Math.sin(cnt++)*angleModDir
      if Math.abs(angleMod)>=90
        #lastBranches[0].len *=1.25
        angleModDir = -angleModDir
        angleMod = 0

    returnFunct = ->
      renderCnt = (Math.round cnt/100)+1
      while renderCnt--
        render()

