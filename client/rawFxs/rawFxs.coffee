###   E X A M P L E S

doTask "draw", "arc", 2, .05, .1 # Speed ? # rnd1 0-1 # rnd2 0-1
doTask "loadImage", null,null, W,H # posX # posY # Width # Height

###

module.exports = (canvas, W, H, fps)->
  ctx = canvas.getContext '2d'
  ctx.patternQuality = 'best'
  ctx.filter = 'best'
  ctx.antialias = 'subpixel'
  ctx.imageSmoothingEnabled = true

  i = 0

  drawTaskFunctions =
    draw: require("./Draw.coffee").Draw ctx, W, H
    pixelPulator: require("./PixelPulator").PixelPulator ctx, W, H
    zoom: require("./Zoom.coffee").Zoom ctx, W, H
    loadImage: require("./LoadImage.coffee").LoadImage ctx, W, H
    mandelbrot: require("./Mandelbrot.coffee").Mandelbrot ctx, W, H
    street: require("./Street3d.coffee").Street ctx, W, H
    starfield: require("./Starfield.coffee").Starfield ctx, W, H
    tron: require("./Tron.coffee").Tron ctx, W, H
    maze: require("./Maze.coffee").Maze ctx, W, H
    flight: require("./Flight.coffee").Flight ctx, W, H
    rotate: (deg)->
      ctx.translate(W/2, H/2)
      ctx.rotate (deg)*Math.PI/180
      ctx.translate(-W/2, -H/2)
    text: (txt, x, y)->
      ctx.font = "30px Arial"
      ctx.fillStyle = "#fff"
      ctx.fillText txt, x, y

  doTask = -> drawTaskFunctions[arguments[0]](
      arguments[1], arguments[2], arguments[3], arguments[4],
      arguments[5], arguments[6], arguments[7], arguments[8]
    )
