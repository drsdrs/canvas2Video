{ FPS, W, H } = require '../config'
fs = require 'fs'
async = require 'async'

module.exports = (stage, cb)->
  scenes = {}
  functs = []
  ls = fs.readdirSync __dirname+'/scenes'

  superCb = ->
    cb
      scenes: scenes
      get: (sceneName)-> @scenes[sceneName].init

  addScene = (filename)->
    returnFunct = (cb)->
      filenameArr = filename.split '.'
      name = filenameArr[0]
      return cb() if name=="getScenes" || filenameArr[1]!='coffee' || !filenameArr[1]?
      scenes[name] = require(__dirname+'/scenes/'+filename) stage, W, H, FPS, cb

  ls.forEach (filename, i)-> functs.push addScene(filename)

  async.parallel functs, superCb
