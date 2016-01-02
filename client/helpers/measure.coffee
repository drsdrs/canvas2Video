module.exports =
  lastT: 0
  measure: (msg)->
    t = Date.now()
    if msg? then console.log "#{msg} - time - #{t-@lastT}"
    @lastT = t
