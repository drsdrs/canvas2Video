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
    raw = uri.split(",")[1]
    buffer = new Buffer raw, 'base64'
    @avconv.stdin.write buffer
    cb() if cb?

  stop: ->
    return if !@recording
    @avconv.stdin.end()

  start: ->
    if @recording then return console.log "Rec. in progress"
    else @recording = true
    that = @
    deleteMovie = spawn 'rm', ['./movie.mp4']
    @avconv = spawn 'avconv', [
      '-i', config.audioFile
      #'-c:a', 'mp3'
      #'-c:v', 'libx264'
      #'-y' # overwrite existing file
      #'-an' # disable audio channel
      '-f', 'image2pipe'
      '-r', @fps #, frames per second
      #'-pix_fmt', 'yuv420p' #for compatibility with outdated media players.
      '-i'
      '-'
      './movie.mp4'
    ]
    @avconv.stderr.on 'data', (data)->
      data = data.toString()
      console.log data
      if data.includes('frame= ')
        frames = data.split('frame= ')[1].trim().split(' ')[0]
        console.log 'progress: ' + frames + 'frames'

    @avconv.on 'close', (code)->
      if code != 0 then throw 'avconv doesnt did well...'+code
      if that.recording
        watchMovie = spawn 'totem', ['./movie.mp4']
        that.recording = false
        console.log 'avconv done !'



module.exports = recorder
