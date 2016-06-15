PNG = require('node-png').PNG
spawn = require('child_process').spawn
config = require '../config'

recorder =
  avconv: null
  recording: false
  canvas: null
  init: (canvas, fps)->
    @canvas = canvas
    @fps = fps

  putFrame: (uri, cb)->
    return cb() if !@recording
    #raw = uri.split(",")[1]
    buffer = new Buffer uri#raw#, 'base64'
    png = new PNG buffer, config.W, config.H
    @avconv.stdin.write buffer
    cb() if cb?

  stop: ->
    return if !@recording
    @avconv.stdin.end()

  start: ->
    if @recording then return console.log "Rec. in progress"
    else @recording = true
    that = @
    avconvArgs = [
      #'-r', @fps #, frames per second
      #'-c:a', 'mp3'
      #'-c:v', 'libx264'
      '-y' # overwrite existing file
      #'-an' # disable audio channel
      '-f', 'image2pipe'
      '-r', @fps #, frames per second
      #'-c:v', 'rawvideo'
      #'-pix_fmt', 'yuv420p' #for compatibility with outdated media players.
      '-i'
      '-'
      './movie.mp4'
    ]
    if config.audioFile!=false
      avconvArgs.unshift '-i', config.audioFile
    else
      avconvArgs.unshift '-an'

    console.log avconvArgs
    @avconv = spawn 'ffmpeg', avconvArgs
    @avconv.stderr.on 'data', (data)->
      data = data.toString()
      console.log data
      if data.includes('frame= ')
        frames = data.split('frame= ')[1].trim().split(' ')[0]
        console.log 'progress: ' + frames + 'frames'

    @avconv.on 'close', (code)->
      if code != 0 then throw 'avconv doesnt did well...'+code
      if that.recording
        if config.PREVIEW then spawn 'vlc', ['./movie.mp4']
        that.recording = false
        console.log 'avconv done !'



module.exports = recorder
