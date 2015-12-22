CanvasProcessor = (canvas, W, H, fps)->
  ctx = canvas.getContext("2d")
  ctx.patternQuality = 'best'
  ctx.filter = 'best'
  ctx.antialias = "subpixel"
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


  doTask = -> drawTaskFunctions[arguments[0]] arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]

  ###   E X A M P L E S


  doTask "draw", "arc", 2, .05, .1 # Speed ? # rnd1 0-1 # rnd2 0-1
  doTask "loadImage", null,null, W,H # posX # posY # Width # Height

  ###


  drawTasks = [
    {
      time: 0, loop: true
      draw: ->
        doTask "loadImage", null,null, W,H
        #if i%4==0
        #doTask "pixelPulator", "blackout", 2
        #doTask "draw", "arc", 32, .05, .1 # spd # rnd1 # rnd2
        #doTask "pixelPulator", "blackou", 16
        doTask "zoom", {x: +3, y:-18}
        doTask "pixelPulator", "fadeout", 4
        #ctx.save()
    },{
      time: 60, loop: true
      draw: ->
        doTask "zoom", {x:-7,y:-7}
        doTask "pixelPulator", "whitein", 3
        doTask "rotate", 3
    },{
      time: .8, loop: true
      draw: ->
        #ctx.restore()
        #ctx.save()
    },{
      time: 1, loop: true
      draw: ->
        doTask "pixelPulator", "blackout", 196
        doTask "draw", "tunnel", Math.sin(i/ 18)*24, Math.sin((i+90)/(24+Math.abs (Math.sin(i/44)*36)))*24, 24
    },{
      time: 2, end: true, loop: false, draw:->null
    }
  ]



  taskState = 0
  currentTask = drawTasks[taskState]
  nextTask = drawTasks[(taskState+1)%drawTasks.length]
  taskState = 1
  frameState = 0

  draw:->
    # get new task if needed
    if nextTask.time*fps<=frameState
      frameState++
      if currentTask.end? then return false


      currentTask = drawTasks[taskState]
      nextTask = drawTasks[(taskState+1)%drawTasks.length]
      taskState++
      # check on end task
    #console.log taskState, currentTask

    # do task
    if currentTask.loop==true
      currentTask.draw()
    else if !currentTask.looped?
      currentTask.looped = true
      currentTask.draw()

    frameState++

    #if i%8==0 then mandelbrot -1/dirX, 1/dirX, -1/dirY, 1/dirY, 14


    i++
    true




exports.CanvasProcessor = CanvasProcessor
