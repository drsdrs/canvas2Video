fs = require 'fs'
module.exports = (stage, W, H)->
  scenes = {}
  ls = fs.readdirSync __dirname
  ls.forEach (v,i)->
    name = v.split(".")[0]
    return if name=="getScenes"
    scenes[name] = require(__dirname+'/'+v)(stage, W, H)

  #scenes: scenes
  get: (sceneName)-> scenes[sceneName].init
