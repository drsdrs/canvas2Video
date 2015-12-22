Mandelbrot = (ctx, w, h)->

  mandelIter = (cx, cy, maxIter) ->
    x = 0.0
    y = 0.0
    xx = 0
    yy = 0
    xy = 0
    i = maxIter
    while i-- and xx + yy <= 4
      xy = x * y
      xx = x * x
      yy = y * y
      x = xx - yy + cx
      y = xy + xy + cy
    maxIter - i

  mandelbrot = (xmin, xmax, ymin, ymax, iterations) ->
    img = ctx.getImageData(0, 0, w, h)
    pix = img.data
    ix = 0
    while ix < w
      iy = 0
      while iy < h
        x = xmin + (xmax - xmin) * ix / (w - 1)
        y = ymin + (ymax - ymin) * iy / (h - 1)
        i = mandelIter(x, y, iterations)
        ppos = 4 * (w * iy + ix)
        if i > iterations
          pix[ppos] = 0
          pix[ppos + 1] = 0
          pix[ppos + 2] = 0
        else
          c = 3 * Math.log(i) / Math.log(iterations - 1.0)
          if c < 1
            pix[ppos] = 255 * c
            pix[ppos + 1] = 0
            pix[ppos + 2] = 0
          else if c < 2
            pix[ppos] = 255
            pix[ppos + 1] = 255 * (c - 1)
            pix[ppos + 2] = 0
          else
            pix[ppos] = 255
            pix[ppos + 1] = 255
            pix[ppos + 2] = 255 * (c - 2)
        pix[ppos + 3] = 128*c
        ++iy
      ++ix
    ctx.putImageData img, 0, 0





exports.Mandelbrot = Mandelbrot