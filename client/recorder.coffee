module.exports =
  avconv: null
  recording: false
  canvas: null
  putFrame: (keepOn, cb)->
    if @recording==false then return cb() if cb?
    uri = @canvas.toDataURL()
    regex = /^data:.+\/(.+);base64,(.*)$/
    raw = uri.match regex
    buffer = new Buffer(raw[2], 'base64')
    if keepOn then @avconv.stdin.write buffer
    else @avconv.stdin.end()
    cb() if cb?

  start: ->
    if @recording then return console.log "Rec. in progress" else @recording = true
    that = @
    deleteMovie = spawn 'rm', ['./movie.mp4']
    @avconv = spawn 'avconv', [
      '-y' # overwrite existing file
      '-f', 'image2pipe'
      '-r', 24 #, frames per second
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
      if code != 0 then throw 'avconv doesnt did well...' + code
      if that.recording
        watchMovie = spawn 'totem', ['./movie.mp4']
        that.recording = false
        console.log 'avconv done !'
