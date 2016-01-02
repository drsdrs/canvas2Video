module.exports = (dir)->
  fs = require 'fs'
  ls = fs.readdirSync(dir)
  allRequired = {}
  ls.forEach (v,i)->
    reqName = v.split('.')
    reqName.pop()
    reqName = reqName.join('.')
    allRequired[reqName] = try require dir+'/'+reqName catch err then err
  allRequired
