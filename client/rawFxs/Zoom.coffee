Zoom = (ctx, w, h)->
  Canvas = document.createElement 'canvas'
  canvasBuffer = document.createElement 'canvas'

  draw = (zoom, src, trg)->
    if zoom
      src = {x:0, y:0, w:w, h:h}
      trg = {x:zoom.x/2, y:zoom.y/2, w:w-zoom.x, h:h-zoom.y}

    imageData = ctx.getImageData src.x, src.y, src.w, src.h

    canvasBuffer.width = src.w
    canvasBuffer.height = src.h

    ctxBuffer = canvasBuffer.getContext("2d")
    ctxBuffer.putImageData imageData, 0, 0

    ctx.drawImage canvasBuffer, trg.x, trg.y, trg.w, trg.h





exports.Zoom = Zoom
