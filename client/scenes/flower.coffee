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

    angleMod = 360

    firstBranch = x: W/2, y:H/2, len: H/8, angle: 270, lenFactor: 1.25
    lastBranches = [ firstBranch ]


    drawBranch = (oldBranch, branches, lenFactor)->
      graph.lineStyle 20/(cnt+1)+0.1, 0x44aa22*(cnt+1), 1
      BRANCHES = branches
      while branches--
        angle = oldBranch.angle - angleMod/2 + angleMod/BRANCHES*(branches+0.5)
        branchEnd = convDeg2d oldBranch.len, convAngleDeg(angle), oldBranch

        return false if branchEnd.x<0||branchEnd.x>W||branchEnd.y<0||branchEnd.y>H

        graph.moveTo oldBranch.x, oldBranch.y
        graph.lineTo branchEnd.x, branchEnd.y


        lastBranches.push
          x:branchEnd.x
          y:branchEnd.y
          angle:angle
          len: oldBranch.len/(lenFactor||oldBranch.lenFactor)
          lenFactor: lenFactor||oldBranch.lenFactor



    draw = ->
      if (cnt++)>18
        graph.clear()
        cnt = 0
        lastBranches = [ firstBranch ]
        angleMod = 360

      tempBranches = lastBranches
      lastBranches = []

      if tempBranches.length>2500
        rndStart = Math.floor Math.random()*(tempBranches.length-500)
        tempBranches = tempBranches.slice rndStart, rndStart+500

      for branch in tempBranches
        drawBranch branch, Math.floor(Math.random()*18/(cnt+1))+1, 1+Math.random()/2

      angleMod = Math.random()*180


