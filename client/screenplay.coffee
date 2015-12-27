module.exports = (stage, renderer, W, H)->

  scenes = require('./scenes/getScenes')(stage, W, H)
  console.log scenes
  [{
    time: 0, loop: true
    init: scenes.get "scene1"

  }, {
    time: .5, loop: true
    init: ->
      videourl = './vids/small.mp4'
      texture = new PIXI.Texture.fromVideo(videourl, .2)
      videoEl = texture.baseTexture.source
      videoEl.loop = "looped"
      videoEl.mute = "muted"
      videoSprite = new PIXI.Sprite texture
      videoSprite.filters = [
        new PIXI.filters.BlurFilter()
        new PIXI.filters.DotScreenFilter(12,1)
      ]

      videoSprite.position.y = 50
      videoSprite.scale.x = .50
      videoSprite.scale.y = .50

      count = 0
      stage.addChild videoSprite
      draw = ->
        videoSprite.position.x = 150+ (Math.sin(count/3) * 50)
        videoSprite.position.y = 100+ (Math.sin(count/4.75) * 80)
        videoSprite.scale.x = Math.abs (Math.sin(count/10))
        videoSprite.scale.y = Math.abs(Math.sin(count/10))
        count += .1

  }, {
    time: 1, loop: true
    init: scenes.get "templateScene"
  }, {
    time: 60, end: true, loop: false
    init: ->
      console.log "EndInit  4"
      draw = -> console.log "Enddraw  4"
  }]
