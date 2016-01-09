{ W, H } = require '../../config'


module.exports =
  drawCircleRing: (arr, pos, graph)->
    WH = if W>H then W else H
    size = WH / arr.length
    arr.forEach (v,i)->
      graph.lineStyle 1.5, i*0x0000ff, v/WH
      graph.drawCircle pos.x, pos.y, (size*i)+v/WH*16
