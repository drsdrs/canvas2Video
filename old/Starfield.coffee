conv3d2d = (x, y, z, centre, zoom, pos)->
  if pos
    x+=pos.x
    y+=pos.y
  resX = x / z * zoom + centre.x
  resY = y / z * zoom + centre.y
  {x:resX, y:resY}

Starfield = (ctx, W, H)->
  ii = 0
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

  starData = []
  flySpd = 16
  starAmount = 1200
  startOutStarAmount = 3
  maxDepth = 800
  maxWeight = 2
  centre = {x: W/2, y:H/2}

  draw = (intro, param1, param2, param3)->
    ii++
    zoom = 1
    i = 0

    flySpd = param1||flySpd
    starAmount = param2||starAmount
    rndSpd = flySpd/2

    #centre.x = W/2+(Math.sin((ii/80)%360)*W/4);

    appendStar = (i, z)->
        x: Math.sin(Math.random()*90)*W*maxDepth/4
        y: Math.sin(Math.random()*90)*H*maxDepth/4
        z: z||Math.random()*maxDepth
        s: flySpd+(Math.random()*rndSpd)
        w: 0.1 + (Math.random()*maxWeight)

    if starData.length==0 # fill star data
      if !intro
        while i<starAmount
          starData[i] = appendStar i++
      else
        while i<starAmount then starData[i] = appendStar i++

    while starData[i]?
      s = starData[i]
      a = Math.round 255-(255/maxDepth*s.z)
      p = conv3d2d s.x, s.y, s.z, centre, zoom
      #console.log a

      setColor "stroke", {r:a, g:a, b:a, a:1}
      ctx.lineWidth = .5

      ctx.beginPath()
      ctx.moveTo p.x, p.y-s.w
      ctx.lineTo p.x, p.y+s.w
      ctx.moveTo p.x-s.w, p.y
      ctx.lineTo p.x+s.w, p.y
      ctx.stroke()

      if s.z<0
        starData[i] = appendStar i, maxDepth
      else
        s.z-= s.s
        starData[i] = s

      if starData.length<starAmount&&Math.random()<0.0125
        starData.push appendStar i, maxDepth


      i++




exports.Starfield = Starfield

