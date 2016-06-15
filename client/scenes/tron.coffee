{W, H, FPS, frameState} = require '../../config'


conv3d2d = (x, y, z)->
  center = { x:W/2, y:H/2 }
  zoom = 1
  [x/z*zoom+center.x, y/z*zoom+center.y]


module.exports = (stage, renderer, cb)->
  cb()
  init: ->
    graph = new PIXI.Graphics
    graph.position.x = 0
    graph.position.y = 0
    stage.addChild graph

    drivers = [
      {
        pos: x:W/2, y:0, z:1
        dir: x:0, y:0, z:1
        cnt: 0
        speed: 1
        color: 0x0000ff
      }, {
        pos: x:-W/2, y:0, z:1
        dir: x:0, y:0, z:1
        cnt: 0
        speed: 2
        color: 0x00ff00
      }, {
        pos: x:0, y:H/2, z:1
        dir: x:0, y:0, z:1
        cnt: 0
        speed: 3
        color: 0xff0000
      }, {
        pos: x:0, y:-H/2, z:1
        dir: x:0, y:0, z:1
        cnt: 0
        speed: 3
        color: 0xffff00
      }
    ]

    changeDir = (driver)->
      tempX = driver.dir.x
      driver.dir.x = driver.dir.y
      driver.dir.y = driver.dir.z
      driver.dir.z = tempX
      #if driver.dir.x+driver.dir.y+driver.dir.z > driver.speed then
      console.log driver.dir.x,driver.dir.y,driver.dir.z
      #driver.speed += 1


    moveDriver = (driver)->
      if Math.random()<.025 then changeDir driver
      if driver.pos.x>W/2
        driver.dir.x = -driver.dir.x
        driver.pos.x = W/2
      else if driver.pos.x<-W/2
        driver.dir.x = -driver.dir.x
        driver.pos.x = -W/2
      else if driver.pos.y>H/2
        driver.dir.y = -driver.dir.y
        driver.pos.y = H/2
      else if driver.pos.y<-H/2
        driver.dir.y = -driver.dir.y
        driver.pos.y = -H/2
      else if driver.pos.z>10
        driver.dir.z = -driver.dir.z
        driver.pos.z = 10
      else if driver.pos.z<1
        driver.dir.z = -driver.dir.z
        driver.pos.z = 1
      driver.pos.x += driver.dir.x*driver.speed
      driver.pos.y += driver.dir.y*driver.speed
      driver.pos.z += driver.dir.z*driver.speed/100
      driver.cnt += 1


    draw = ()->
      for driver in drivers
        graph.lineStyle 0
        graph.beginFill driver.color, 0.5

        e = conv3d2d driver.pos.x, driver.pos.y, driver.pos.z
        graph.drawCircle e[0], e[1], (15/driver.pos.z)+1
        moveDriver driver

