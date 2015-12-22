conv3d2d = (x, y, z, centre, zoom, pos)->
  if pos
    x+=pos.x
    y+=pos.y
  resX = x / z * zoom + centre.x
  resY = y / z * zoom + centre.y
  {x:resX, y:resY}

Street = (ctx, W, H)->
  i = 0
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

  setColor = (type, c)-> ctx[type+"Style"] = "rgba("+(c.r)+","+(c.g)+","+(c.b)+","+(c.a)+")"

  street = []
  streetPos = x:0, y:H, z:1
  streetZ = 0
  streetZSpd = 0.000125
  streetCol = 0

  draw = (type, param1, param2, param3, param4)->
    i++
    centre = {x: W/2, y:H/3}
    zoom = 1
    z = 0

    lastPos = {x1:1000, x2:-1000, y1:H, y2:H}

    partsY = 0

    endZ = 360


    appendStreet = (z, angleModX, angleModY)->
        street[z] = x:streetPos.x, y:streetPos.y
        if Math.random()>0.9 then street[z].obj = streetPos.x-120
        if streetPos.y<-4000||streetPos.y>4000 then dir.y = -dir.y; spd.x = Math.random()*10
        if streetPos.x<-3000||streetPos.x>3000 then dir.x = -dir.x; spd.y = Math.random()*10
        if dir.y==1 then streetPos.y+=spd.y else streetPos.y-=spd.y
        if dir.x==1 then streetPos.x+=spd.x else streetPos.x-=spd.x
        #console.log streetPos.y, streetPos.x

    if street.length<endZ
      amodx = Math.floor Math.random()*90
      amody = Math.floor Math.random()*90
      while z<endZ
        appendStreet z++#, amodx, amody
        z = ~~z
      z = 0

    # draw horizont
    setColor "stroke", {r:255, g:255, b:255, a:1}
    ctx.lineWidth = .1
    ctx.beginPath()
    ctx.moveTo 0, centre.y
    ctx.lineTo W, centre.y
    ctx.stroke()


    alpha = 1
    while z<endZ
      if z<endZ/3
        alpha -= alpha/endZ*14
      #console.log alpha
      #street.push appendStreet(endZ-1)

      streetZSpd += 0.00000125
      streetZ += streetZSpd
      if streetZ>=1
        streetZ = 0
        streetCol+=.1
        firstPiece = street.shift()
        street.push appendStreet(endZ-1)

      if alpha<0.00001
        return z= endZ

      setColor "stroke", {r:255, g:255, b:255, a:alpha}
      ctx.beginPath()
      xXx = street[z].x/((20/z)+1)
      yYy = (H-75)+(street[z].y/((40/z)+1))
      setColor "fill", {r:((z+streetCol)*32)&255, g:(255-(((street[z].y/H)*8)+128))&255, b:0, a:alpha}
      p1 = conv3d2d 333+xXx, yYy-xXx/7, (z+.01)*1, centre, zoom
      p2 = conv3d2d -333+xXx, yYy+xXx/7, (z+.01)*1, centre, zoom
      p3 = conv3d2d 999+xXx, 0, (z+.01)*1, centre, zoom
      p4 = conv3d2d -999+xXx, 0, (z+.01)*1, centre, zoom
      ctx.moveTo p1.x, p1.y
      ctx.lineTo p2.x, p2.y
      ctx.lineTo lastPos.x2, lastPos.y2
      ctx.lineTo lastPos.x1, lastPos.y1
      ctx.lineTo p1.x, p1.y

      ctx.moveTo p2.x, p2.y
      ctx.lineTo p4.x, p4.y
      ctx.moveTo p1.x, p1.y
      ctx.lineTo p3.x, p3.y

      ctx.stroke()
      ctx.fill()



      lastPos = {x1:p1.x, x2:p2.x, y1:p1.y, y2:p2.y}

      z++




exports.Street = Street

