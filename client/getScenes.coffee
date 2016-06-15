fs = require 'fs'
async = require 'async'

module.exports = (stage, renderer, cb)->
  scenes = {}
  functs = []
  ls = fs.readdirSync __dirname+'/scenes'

  superCb = ->
    cb
      scenes: scenes
      get: (sceneName)->
        console.log 'init '+sceneName
        if @scenes[sceneName].init? then @scenes[sceneName].init else console.log 'wrong syntax in '+sceneName

  addScene = (filename)->
    returnFunct = (cb)->
      filenameArr = filename.split '.'
      name = filenameArr[0]
      return cb() if name=="getScenes" || filenameArr[1]!='coffee' || !filenameArr[1]?
      scenes[name] = require(__dirname+'/scenes/'+filename) stage, renderer, cb

  ls.forEach (filename, i)-> functs.push addScene(filename)

  async.parallel functs, superCb
