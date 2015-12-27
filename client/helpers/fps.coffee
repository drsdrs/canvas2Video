module.exports =
  startTime: 0
  frameNumber: 0
  fps: 0
  getFPS: ->
    @frameNumber++
    d = (new Date).getTime()
    currentTime = (d - (@startTime)) / 1000
    result = Math.floor(@frameNumber / currentTime)
    if currentTime > 1
      @startTime = (new Date).getTime()
      @frameNumber = 0
    @fpsAvg = Math.round ((@fpsAvg||result)+result)/2
    @fps = result
    result
