effectPath = __dirname+'/../libs/Seriously/effects/'

Seriously =  require __dirname+'/../libs/Seriously/seriously.js'
effects = require(__dirname+'/../helpers/requireAll') effectPath

module.exports = (stage, W, H, FPS, cb)->
  cb()
  init: ->
    seriously = new Seriously()
    videourl = './vids/small.mp4'
    videourl = './vids/smpl_360x240.mp4'
    canvasEl = document.createElement 'canvas'
    textureCanvas = new PIXI.Texture.fromCanvas(canvasEl, 1)

    count = 0
    canvasSprite = new PIXI.Sprite textureCanvas
    canvasSprite.position = x: 0, y: 0
    canvasSprite.scale = x: 1, y: 1
    stage.addChild canvasSprite

    videoEl = document.createElement 'video'
    videoEl.src = videourl
    videoEl.loop = "looped"
    videoEl.mute = "muted"
    console.log x:videoEl

    videoEl.oncanplay = ()->
      canvasSprite.width = videoEl.videoHeight
      canvasSprite.height = videoEl.videoWidth

      sourceCanvas = seriously.source videoEl
      target = seriously.target canvasEl
      vignette = seriously.effect 'ascii'
      vignette.source = sourceCanvas
      target.source = vignette
      seriously.go() # connect all our nodes in the right order
      videoEl.play()

    draw = ->
      #canvasSprite.position.x = -50+ (Math.sin(count/3) * 50)
      #canvasSprite.position.y = -50+ (Math.sin(count/4.75) * 80)
      canvasSprite.scale.x = 1.5 + Math.abs(Math.sin(count/33))*3
      canvasSprite.scale.y = 2 + Math.abs(Math.sin(count/44))*3
      count += .1
      seriously.render()
