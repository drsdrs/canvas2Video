module.exports = ->
  lastT= 0
  it = (msg)->
    t = Date.now()
    if msg? then console.log "#{msg} - time - #{t-lastT}"
    lastT = t
