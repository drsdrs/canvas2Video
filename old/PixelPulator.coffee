PixelPulator = (ctx, W, H)->
  Canvas = document.createElement("canvas")

  i = 0
  X = 0
  Y = 0

  colorBuffer = new Uint8Array(W*H*4)
  colorBufferLength = W/8
  colorBufferIndex = 0

  draw = (type, param1)->
    i+=4.5
    imageData = ctx.getImageData 0, 0, W, H
    data = imageData.data
    len = data.length

    XX = -> # draw artefacts in empty space
      j = data.length
      while j--
        res = data[(Math.round(j+len/(param1||(i/9)%8))%len)]
        data[j] =
          if data[j]==0
            res
          else data[j]
      ctx.putImageData(imageData, 0, 0)

    WW = ->
      x = 0
      while x<W
        y = 0
        while y<H
          j = (y*W+x)*4
          data[j] = if ((y-H/2))%60==0||((x-W/2))%60==0 then (i%255)^y^x else data[j]
          data[j+1] = if ((y-H/ 2))%15==0 then (x-W/2)^(y-H/2)/((i/25)%196) else data[j+1]
          data[j+2] = if ((x-W/2))%15==0 then ((i/100)%8)*(y-H/2)^(x-W/2) else data[j+2]
          data[j+3] = 255
          y++
        x++
      ctx.putImageData imageData, 0, 0

    YY = ->
      x = 0
      while x<W
        y = 0
        while y<H
          j = (y*W+x)*4
          data[j] = if (y+i)%24==0 then ((x+i)*4)&255 else 0
          data[j+1] = if (x-i)%16==0 then (y-i)&255 else 0
          data[j+2] = if (y+x-i)%32==0 then (y+x-i)&255 else 0
          data[j+3] = 255
          y++
        x++
      ctx.putImageData imageData, 0, 0

    fadeout = ->
      x = 0
      while x<W
        y = 0
        while y<H
          j = (y*W+x)*4
          data[j+3] -= param1||8
          y++
        x++
      ctx.putImageData(imageData, 0, 0)

    blackout = ->
      x = 0
      while x<W
        y = 0
        while y<H
          j = (y*W+x)*4
          data[j] -= param1||8
          data[j+1] -= param1||8
          data[j+2] -= param1||8
          y++
        x++
      ctx.putImageData(imageData, 0, 0)

    whitein = ->
      x = 0
      while x<W
        y = 0
        while y<H
          j = (y*W+x)*4
          data[j] += param1||8
          data[j+1] += param1||8
          data[j+2] += param1||8
          y++
        x++
      ctx.putImageData(imageData, 0, 0)

    clear = ->
      j = data.length
      while j-- then data[j] = 0
      ctx.putImageData(imageData, 0, 0)

    colorShift = ->
      x = 0
      while x<W
        y = 0
        while y<H
          i = (y*W+x)*4
          if colorBuffer[colorBufferIndex]>0
            data[i] = (data[i]+colorBuffer[colorBufferIndex])/1.99
          if colorBuffer[colorBufferIndex+1]>0
            data[i+1] = (data[i+1]+colorBuffer[colorBufferIndex+1])/1.99
          if colorBuffer[colorBufferIndex+2]>0
            data[i+2] = (data[i+2]+colorBuffer[colorBufferIndex+2])/1.99
          colorBuffer[colorBufferIndex] = data[i]
          colorBuffer[colorBufferIndex+1] = data[i+1]
          colorBuffer[colorBufferIndex+2] = data[i+2]
          colorBufferIndex+=4
          colorBufferIndex = colorBufferIndex%(colorBuffer.length)
          y++
        x++
      ctx.putImageData(imageData, 0, 0)

    if type=="fadeout" then fadeout()
    else if type=="blackout" then blackout()
    else if type=="whitein" then whitein()
    else if type=="tri" then tri()
    else if type=="clear" then clear()
    else if type=="colorShift" then colorShift()
    else if type=="w" then XX()
    else if type=="colorize"
      x = 0
      while x<W
        y = 0
        while y<H
          i = (y*W+x)*4
          buf = colorBuffer[i%colorBufferLength]||[128,128,128]
          if param1==0 # black out
            data[i] = (data[i]+buf[0]/32)-255/8
            data[i+1] = (data[i+1]+buf[1]/16)-255/8
            data[i+2] = (data[i+2]+buf[2]/8)-255/8
          else if param1==1 # invert flash
            data[i] = (data[i]+buf[0]/32)^255
            data[i+1] = (data[i+1]+buf[1]/32)^255
            data[i+2] = (data[i+2]+buf[2]/32)^255
          else if param1==2 # eat flesh, zombie!
            data[i] = (data[i]+buf[0]/32)&255
            data[i+1] = (data[i+1]+buf[1]/32)&255
            data[i+2] = (data[i+2]+buf[2]/32)&255
          else if param1==3 # melt down
            data[i] = (buf[0]++)&255
            data[i+1] = ((data[i+1]+buf[1])>>1)&255
          else if param1==4
            data[i] = if data[i]>128 then ((data[i]+buf[0]/2))&255 else ((data[i]*x)>>8)&255
            data[i+1] = if data[i+1]<128 then ((data[i+1]+buf[0]/2))&255 else ((data[i+1]*y)>>8)&255
            data[i+2] = if data[i+2]>128 then ((data[i+2]+buf[0]/2))&255 else ((data[i+2]*y)>>8)&255
          else
            data[i] = (((data[i]+buf[0]))/2)&255
            data[i+1] = (((data[i+1]+buf[2]))/2)&255
            #data[i+1] = ((data[i+1]+buf[1]*(W-x))>>8)&255
            #data[i+2] = ((data[i+2]+buf[2]*y)>>8)&255

          colorBuffer[i%colorBufferLength] = [ data[i], data[i+1], data[i+2], data[i+3] ]
          y++
        x++
      ctx.putImageData(imageData, 0, 0)

    # zoom.x-=zoom.x/2 if zoom.x>0
    # zoom.y-=zoom.y/2 if zoom.y>0

    # setInterval ->
    #   zoom.x = zoom.y = 20
    # , 5000

    # ctx.drawImage(canvasBuffer, zoom.x, zoom.y, W-zoom.x*2, H-zoom.y*2)


exports.PixelPulator = PixelPulator
