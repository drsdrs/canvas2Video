fs = require 'fs'
image = document.createElement "canvas"

imgPath = __dirname+'/../imgs/'
images = []

fs.readdir imgPath, (err, res)->
  if err then throw err
  images = res


LoadImage = (ctx, w, h)->

  getRndImg = ()-> images[ Math.floor Math.random()*images.length ]

  load = (ix, iy, iw, ih)->
    filepath = imgPath+getRndImg()
    fs.readFile filepath, (err, imgData)->
      if err then throw err
      img = image
      img.src = imgData

      imgRatio = img.width/img.height
      iw = iw||ih*imgRatio
      ih = ih||iw/imgRatio

      if typeof(ix)!="number" then ix = (w-iw)/2
      if typeof(iy)!="number" then iy = (h-ih)/2

      ctx.drawImage img, ix, iy, iw, ih

exports.LoadImage = LoadImage
