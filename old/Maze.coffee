conv3d2d = (x, y, z, centre, zoom)-> x: x/z*(zoom||1)+centre.x, y: y/z*(zoom||1)+centre.y
convDeg2d = (l, deg, centre)-> x: (l*Math.cos(deg))+centre.x, y: (l*Math.sin(deg))+centre.y


rgbToHex = (r, g, b) -> "#"+componentToHex(r)+componentToHex(g)+componentToHex(b)
componentToHex = (c)->
    hex = c.toString(16)
    hex.length == 1 ? "0" + hex : hex




Maze = (ctx, W, H)->
  i = 0

  centre = {x:W/2, y:H/2}

  spd =
    x: 0
    y: 6

  dir =
    x: 1
    y: 1

  pos =
    x: W/2
    y: H/2
    z: 20

  col =
    fill:
      r: 255
      g: 0
      b: 0
      a: 1
    stroke:
      r: 255
      g: 255
      b: 255
      a: 1

  x = 0
  y = 0

  getColor = (trg)->
    if trg.x>=W||trg.x<0 then return false
    if trg.y>=H||trg.y<0 then return false
    ctx.getImageData(trg.x, trg.y, 1, 1).data


  setColor = (type, newColor)->
    if newColor? then col[type] = newColor
    c = col[type]
    ctx[type+"Style"] = "rgba("+(c.r)+","+(c.g)+","+(c.b)+","+(c.a)+")"

  draw = (param1, param2, param3, param4)->
    i++

    wireRes = 32
    wirePos = 0
    stepSizeX = W/wireRes
    stepSizeY = H/wireRes
    stepSizeZ = 3/wireRes
    max = x:W, y:H, z:33
    zVisit = false
    # wireframe box

    drawMaze = (xx, yy)->
      s = W/64
      dir = x: 0, y: s
      pos = x: s*32, y: H/2
      setColor "stroke", {r:255, g:255, b:128, a:1}
      ctx.strokeWidth = s

      u = 0
      moveAlong = (pos, dir)->
        u++
        blackSpot = getColor(x:pos.x+dir.x, y:pos.y+dir.y)[0]<128
        inBounds = pos.x>s && pos.x<(W-s) && pos.y>s && pos.y<(H-s)
        console.log blackSpot,inBounds, pos, dir
        if u>800 then return false
        if blackSpot && inBounds
          ctx.beginPath()
          ctx.moveTo pos.x, pos.y
          pos.x += dir.x
          pos.y += dir.y
          ctx.lineTo pos.x, pos.y
          ctx.stroke()
          # spread in 4 directions
          moveAlong pos, {x:s, y:0}
          moveAlong pos, {x:-s, y:0}
          moveAlong pos, {x:0, y:s}
          moveAlong pos, {x:0, y:-s}
        else
          return false


      moveAlong pos, dir

    drawMaze()


    ctx


exports.Maze = Maze

