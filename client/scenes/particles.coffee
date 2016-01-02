module.exports = (stage, W, H, FPS, cb)->
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
      'alpha': 'start': 1, 'end': 1
      'scale': 'start': 1, 'end': 0
      'color': 'start': 'ff00ff', 'end': '0fffff'
      'speed': 'start': 1, 'end': 140
      'startRotation': 'min': 0, 'max': 360
      'rotationSpeed': 'min': 2, 'max': -8
      'lifetime': 'min': 0, 'max': 12
      'frequency': 0.0125
      'emitterLifetime': 162.8
      'maxParticles': 120
      'pos': 'x': W/2, 'y': H/2
      'addAtBack': true
      'spawnType': 'circle'
      'spawnCircle': 'x': 50, 'y': 50, 'r': 50

    particleImages = [ PIXI.Texture.fromImage __dirname+'/assets/particle.png' ]

    emitter = new cloudkid.Emitter stage, particleImages, emitters.special

    elapsed = Date.now()
    emitter.emit = true;

    draw = ->
      now = Date.now()
      emitter.update (now - elapsed) * 0.001
      elapsed = now
