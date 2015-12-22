conv3d2d = (x, y, z, centre, zoom)-> x: x/z*zoom+centre.x, y: y/z*zoom+centre.y
convDeg2d = (l, deg, centre)-> x: (l*Math.cos(deg))+centre.x, y: (l*Math.sin(deg))+centre.y

Draw = (ctx, W, H)->
  i = 0
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

  side = [2, 0]
  direction = [1, -1]
  spd = 8
  setNextDir = (nr, move)->
    speed = Math.max(Math.abs(dir["x"+(nr+1)]), Math.abs(dir["y"+(nr+1)]) )

    if speed<.5 then speed = spd
    else if speed>spd then speed*=0.25

    if move
      side[nr] = (direction[nr]+side[nr])%4
      if side[nr]<0 then side[nr]=3
    direct = direction[nr]
    sid = side[nr]
    nr++
    if sid==0
      dir["x"+nr] = if direct>0 then speed else -speed
      pos["x"+nr] = if direct>0 then 0 else W
      dir["y"+nr] = 0
      pos["y"+nr] = 0
    else if sid==1
      dir["x"+nr] = 0
      pos["x"+nr] = W
      dir["y"+nr] = if direct>0 then speed else -speed
      pos["y"+nr] = if direct>0 then 0 else H
    else if sid==2
      dir["x"+nr] = if direct>0 then -speed else speed
      pos["x"+nr] = if direct>0 then W else 0
      dir["y"+nr] = 0
      pos["y"+nr] = H
    else if sid==3
      dir["x"+nr] = 0
      pos["x"+nr] = 0
      dir["y"+nr] = if direct>0 then -speed else speed
      pos["y"+nr] = if direct>0 then H else 0

  setColor = (type, newColor)->
    if newColor? then col[type] = newColor
    c = col[type]
    ctx[type+"Style"] = "rgba("+(c.r)+","+(c.g)+","+(c.b)+","+(c.a)+")"

  draw = (type, param1, param2, param3)->
    spd = param1||spd
    if true # newone!
      if !pos.x2?
        pos = x1:0, y1:H/2, x2:W ,y2:H/2, px1: W/3, py1: H-22, px2: W/3*2, py2: H-22
        dir = x1:0, y1:0, x2:0 ,y2:0, px1: 1, py1: 7, px2: 2, py2: 9

      # draw lines
      setColor "stroke", {r:(i&255), g:255, b:255, a:1}
      ctx.lineWidth = 1
      ctx.beginPath()
      ctx.moveTo pos.x1, pos.y1
      ctx.bezierCurveTo pos.px1, pos.py1, pos.px2, pos.py2, pos.x2, pos.y2
      ctx.stroke()

      #DEBUG CONTROL POINTS
      # setColor "stroke", {r:255, g:0, b:0, a:1}
      # ctx.lineWidth = 2
      # ctx.beginPath()
      # ctx.moveTo pos.px1, pos.py1
      # ctx.lineTo pos.px2, pos.py2
      # ctx.stroke()

      # check control point out bound
      if pos.px1>=W||pos.px1<=0
        pos.x1 = pos.x1%W
        dir.px1 = -dir.px1
      else if pos.py1>=H||pos.py1<=0
        pos.y1 = pos.y1%H
        dir.py1 = -dir.py1
      else if pos.px2>=W||pos.px2<=0
        pos.x1 = pos.x2%W
        dir.px2 = -dir.px2
      else if pos.py2<=0||pos.py2>=H
        pos.y1 = pos.y2%H
        dir.py2 = -dir.py2

      # add positions with dir's
      pos.px1+=dir.px1
      pos.py1+=dir.py1
      pos.px2+=dir.px2
      pos.py2+=dir.py2


    else if type=="arc"
      if !pos.x2?
        pos = x1:0, y1:0, x2:W ,y2:H, px1: W/3, py1: H/3, px2: W/3*2, py2: H/3*2
        dir = x1:0, y1:0, x2:0 ,y2:0, px1: 3, py1: 1, px2: 7, py2: 2
        setNextDir(0)
        setNextDir(1)

      # check main lines for out bound
      if pos.x1>W||pos.y1>H||pos.x1<0||pos.y1<0 then setNextDir(0, true)
      if pos.x2>W||pos.y2>H||pos.x2<0||pos.y2<0 then setNextDir(1, true)

      # draw lines
      setColor "stroke", {r:255, g:255, b:255, a:1}
      ctx.lineWidth = 1
      ctx.beginPath()
      ctx.moveTo pos.x1, pos.y1
      ctx.bezierCurveTo pos.px1, pos.py1, pos.px2, pos.py2, pos.x2, pos.y2
      ctx.stroke()

      # DEBUG CONTROL POINTS
      # setColor "stroke", {r:255, g:0, b:0, a:1}
      # ctx.lineWidth = 2
      # ctx.beginPath()
      # ctx.moveTo pos.px1, pos.py1
      # ctx.lineTo pos.px2, pos.py2
      # ctx.stroke()

      # check control point out bound
      if pos.px1>=W||pos.py1>=H||pos.px1<=0||pos.py1<=0
        dir.px1 = -dir.px1
        dir.py1 = -dir.py1
      if pos.px2>=W||pos.py2>=H||pos.px2<=0||pos.py2<=0
        dir.px2 = -dir.px2
        dir.py2 = -dir.py2

      # add positions with dir's
      pos.x1+=dir.x1
      pos.y1+=dir.y1
      pos.x2+=dir.x2
      pos.y2+=dir.y2
      pos.px1+=dir.px1
      pos.py1+=dir.py1
      pos.px2+=dir.px2
      pos.py2+=dir.py2

      # speed up lines after dirChange or random reverse
      dir.x1*=1.05
      dir.x2*=1.05
      dir.y1*=1.05
      dir.y2*=1.05

      # reverse direction based on random number
      if Math.random()<(param2||.01)
        if dir.x1>0.2||dir.y1>0.2
          direction[0]=-direction[0]
          dir.x1 = -dir.x1*0.5
          dir.y1 = -dir.y1*0.5
      if Math.random()<(param3||.01)
        if dir.x1>0.2||dir.y1>0.2
          direction[1]=-direction[1]
          dir.x2 = -dir.x2*0.5
          dir.y2 = -dir.y2*0.5

    else if type=="spiral"
      j = 0
      pos = x:W/2,y:H/2
      ctx.beginPath()
      ctx.strokeStyle = "#fff"
      ctx.fillStyle = "#fff"
      setColor "stroke", {r:255, g:255, b:255, a:1}
      ctx.lineWidth = 1
      ctx.moveTo pos.x, pos.y
      while pos.x>-W/2 && pos.y>-H/2 && pos.x<(W*1.5) && pos.y<(H*1.5) && j<2000
        distance = j*(param1||4)
        deg = i+((j*(param2||.9025))%360)
        pos = convDeg2d distance, deg, { x: W/2, y:H/2 }
        ctx.lineTo pos.x, pos.y
        j++
      ctx.stroke()
      ctx.fill()

    else if type=="tunnel"
      i+=param4
      endSize = W/10
      spdX = param1||2
      spdY = param2||3
      step = 0
      steps = param3||6
      stepSizeX = (W-endSize)/steps
      stepSizeY = (H-endSize)/steps
      strokeStep = 255/steps
      while step<steps
        rx = ((W/2-endSize/2)-((stepSizeX-(spdX*(steps-step-1)/steps))*step/2))
        ry = ((H/2-endSize/2)-((stepSizeY-(spdY*(steps-step-1)/steps))*step/2))
        rw = (endSize+stepSizeX*step)
        rh = (endSize+stepSizeY*step)

        setColor "stroke", {r:255, g:255, b:255, a:(step/steps)}
        ctx.beginPath()
        ctx.rect rx, ry, rw, rh
        ctx.stroke()
        step++


    else if type=="spiderArm"
      p = pos
      if p.x>W||p.x<0 then dir.x=-dir.x
      if p.y>H||p.y<0 then dir.y=-dir.y
      p.x+=dir.x
      p.y+=dir.y
      c = col.stroke

      p.z += 1.5
      wire = (xx,yy,cnt,alpha)->
        if !cnt? then cnt = 0
        cnt++
        xxx = Math.sin((xx+p.z)/25)*(p.z%W/2)
        yyy = Math.sin((yy+150+p.z)/25)*(p.z%H/2)
        c.a = alpha
        ctx.beginPath()
        alpha *= 0.75
        setColor "stroke", c
        ctx.moveTo xx, yy
        if xx<W/2 then xx -= xxx else xx += xxx
        if yy<H/2 then yy -= yyy else yy += yyy
        ctx.lineTo(xx, yy)
        ctx.stroke()

        if yy<0||yy>H||xx<0||xx>W||cnt>66||alpha<0.01
          return cnt
        else wire xx, yy, cnt, alpha

      c = {r:0,g:0,b:0,a:0}
      len = 1
      while len--
        c.r = (c.r+=8)&255
        c.g = (c.g+=16)&255
        c.b = 196
        wire (W/2+len*5)-0, H/2, 0, 1


    ++i


exports.Draw = Draw

