conv3d2d = (x, y, z, centre, zoom)-> x: x/z*(zoom||1)+centre.x, y: y/z*(zoom||1)+centre.y
convDeg2d = (l, deg, centre)-> x: (l*Math.cos(deg))+centre.x, y: (l*Math.sin(deg))+centre.y


rgbToHex = (r, g, b) -> "#"+componentToHex(r)+componentToHex(g)+componentToHex(b)
componentToHex = (c)->
    hex = c.toString(16)
    hex.length == 1 ? "0" + hex : hex




Tron = (ctx, W, H)->
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

  readPixel = (trg)->
    if trg.x>=W||trg.x<0 then return false
    if trg.y>=H||trg.y<0 then return false
    ctx.getImageData(trg.x, trg.y, 1, 1).data


  setColor = (type, newColor)->
    if newColor? then col[type] = newColor
    c = col[type]
    ctx[type+"Style"] = "rgba("+(c.r)+","+(c.g)+","+(c.b)+","+(c.a)+")"

  draw = (param1, param2, param3, param4)->
    i++

    #if p.x>W||p.x<0 then dir.x=-dir.x
    #if p.y>H||p.y<0 then dir.y=-dir.y
    #p.x+=dir.x
    #p.y+=dir.y

    wireRes = 32
    wirePos = 0
    stepSizeX = W/wireRes
    stepSizeY = H/wireRes
    stepSizeZ = 3/wireRes
    max = x:W, y:H, z:33
    zVisit = false
    # wireframe box

    wireDown = (xx, yy)->
      dir = x: 0, y: 0, z: -stepSizeZ
      pos = x: (W/2)-(xx*stepSizeX), y: (H/2)-(yy*stepSizeY), z:-stepSizeZ

      setColor "stroke", {r:64, g:64, b:64, a:1}
      ctx.strokeWidth = 0.1
      ctx.beginPath()
      ctx.moveTo 0, 0
      ctx.lineTo W/3, H/3
      ctx.lineTo W/3*2, H/3
      ctx.lineTo W, 0
      ctx.moveTo 0, H
      ctx.lineTo W/3, H/3*2
      ctx.lineTo W/3*2, H/3*2
      ctx.lineTo W, H
      ctx.moveTo W/3, H/3
      ctx.lineTo W/3, H/3*2
      ctx.moveTo W/3*2, H/3
      ctx.lineTo W/3*2, H/3*2
      ctx.stroke()

      untouched = true
      iii = 0
      while untouched
        setColor "stroke", {r:255, g:(pos.z*255/3)&255, b:0, a:1}
        #console.log col.stroke
        if ++iii>100 then console.log "overburn"; untouched= false
        # random change direction clockwise
        if Math.random()<.00125*iii
          if pos.z==-3.00001
            dir = x: -dir.y, y: -dir.x, z:0
          else if (pos.x-stepSizeX)>-W/2&&(pos.x+stepSizeX)<W/2
            dir = x: 0, y: -stepSizeY, z:0
            console.log "UD"
          else if (pos.y-stepSizeY)>-H/2&&(pos.y+stepSizeY)<H/2
            dir = x: -stepSizeX, y: 0, z:0
            console.log "LR"


        src = conv3d2d pos.x, pos.y, pos.z, centre
        pos.x += dir.x
        pos.y += dir.y
        pos.z += dir.z

        if pos.z==-3
          pos.z=-3.00001
          #if zVisit==true then console.log "ZZZZZZZ"
          zVisit = true
          dir =
            if yy==0 then x:0, y:-stepSizeY, z:0
            else if yy==wireRes then x:0, y:stepSizeY, z:0
            else if xx==0 then x:-stepSizeX, y:0, z:0
            else if xx==wireRes then x:stepSizeX, y:0, z:0
            else console.log "ERROR line..."
        else if pos.z>-0 then untouched = false
        else if pos.x>W/2||pos.y>H/2||pos.x<-W/2||pos.y<-H/2
          #pos = x: pos.x%(W/2), y:pos.y%(H/2), z:pos.z
          pos.x -= dir.x
          pos.y -= dir.y
          pos =
            x: Math.max(-W/2, Math.min(pos.x, W/2))
            y: Math.max(-H/2, Math.min(pos.y, H/2))
            z: pos.z
          if pos.z==-3.00001

            dir = x:0, y:0, z:stepSizeZ
          else untouched = false


        #console.log pos

        trg = conv3d2d pos.x, pos.y, pos.z, centre
        avg = x: (trg.x+src.x)/2, y: (trg.y+src.y)/2, z: (trg.z+src.z)/2


        # determe possible moves
        # move upon this data


        # if pos.z<-W/128
        #   pos.z = -W/128
        #   dir =
        #     if pos.y>=H/2 then x:0, y:-stepSizeY, z:0
        #     else if pos.y<=-H/2 then x:0, y:stepSizeY, z:0
        #     else if pos.x>=W/2 then x:-stepSizeX, y:0, z:0
        #     else if pos.x<=-W/2 then x:stepSizeX, y:0, z:0
        #     else console.log "Z - error"; dir
        pixel = readPixel(src)[0]
        if readPixel(trg)[0]>196||readPixel(avg)[0]>196
            untouched = false
            #console.log "color BUM", readPixel(avg)[0],readPixel(src)[0], pixel
          # maybe change dir
        ctx.beginPath()
        #console.log src, trg
        ctx.moveTo src.x, src.y
        ctx.lineTo trg.x, trg.y
        ctx.stroke()

    # start out left-bottom edge

    rx = (Math.floor Math.random()*(wireRes-1))+1
    ry = (Math.floor Math.random()*(wireRes-1))+1
    wireDown(rx, 0)
    wireDown(0, ry)
    rx = Math.round Math.random()*wireRes
    ry = Math.round Math.random()*wireRes
    wireDown(wireRes-rx, wireRes)
    wireDown(wireRes, wireRes-ry)


    x = (++x%(wireRes))
    y = (++y%(wireRes))





    ctx


exports.Tron = Tron

