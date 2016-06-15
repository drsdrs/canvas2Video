{W, H, FPS, frameState} = require '../../config'

module.exports = (stage, renderer, cb)->
  fs = require 'fs'
  ls = fs.readdirSync(__dirname+'/emitters')
  emitters = {}
  ls.forEach (v)->
    name = v.split('.')[0]
    emitters[name] = JSON.parse fs.readFileSync __dirname+'/emitters/'+v
    emitters[name].pos = x: 332, y: 222
  cb()
  init: ->
    container = new PIXI.Container
    container.position = x: W/2, y: H/2
    stage.addChild container
    defaultParticles =
      'alpha': 'start': 0, 'end': 1
      'scale': 'start': 0.1, 'end': 0.3
      'color': 'start': '000000', 'end': 'ffffff'
      'speed': 'start': 1, 'end': 250
      'startRotation': 'min': 0, 'max': 360
      'rotationSpeed': 'min': 2, 'max': -8
      'lifetime': 'min': 8, 'max': 12
      'frequency': 0.0125
      'emitterLifetime': 64
      'maxParticles': 8000
      'pos': 'x': W/2, 'y': H/2
      'addAtBack': true
      'spawnType': 'circle'
      'spawnCircle': 'x': 0, 'y': 0, 'r': 1

    particleImages = [ PIXI.Texture.fromImage __dirname+'/assets/particle.png' ]


    emitter = new cloudkid.Emitter stage, particleImages, defaultParticles
    console.log emitter

    elapsed = Date.now()
    emitter.emit = true;

    draw = ->
      now = Date.now()
      emitter.update (now - elapsed) * 0.001
      elapsed = now
