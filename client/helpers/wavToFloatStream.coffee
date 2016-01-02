config = require '../../config'
measure = require('./MeasureTime')()
async = require 'async'
DataView = require('buffer-dataview')

buildFormula = (format)->
  divider = Math.pow 2, format.bitDepth-1
  shift = if format.signed then 0 else -1
  (input)->
    #console.log input, divider, shift
    (input/divider)-shift

module.exports = (format)->
  Writable = require("stream").Writable
  class ToFloat extends Writable
    result: []
    buildFrameArray: (format)->
      totalArrLength = 0
      @result.forEach (v,i)-> totalArrLength+=v.length
      totalArr = new Uint32Array totalArrLength
      totalArrPos = 0
      @result.forEach (v,i)->
        totalArr.set v, totalArrPos
        totalArrPos += v.length

      waveFrames = []
      waveFramePos = 0
      samplesPerFrame = format.sampleRate/config.FPS*2
      samplesPerFrame = samplesPerFrame-(samplesPerFrame%2)
      samplesToThrowAway = Math.round samplesPerFrame%2
      samplePos = 0
      while samplePos<totalArr.length
        waveFrames[waveFramePos] = totalArr.slice samplePos, samplesPerFrame+samplePos
        waveFramePos++
        samplePos += samplesPerFrame+samplesToThrowAway
      waveFrames
    toStereoBuffers: (data)->
      if format.channels==1 then return [data]
      dataL = new Buffer data.length/2
      dataR = new Buffer data.length/2
      len = data.length
      i = 0
      j = 0
      while i<len
        dataL[j] = data[i++]
        dataR[j] = data[i++]
        j++
      [ dataL, dataR ]
    mergeBufferToType: (data)->
      i = 0
      size = format.blockAlign / format.channels
      len = data.buffer.length / size
      floatArr = new Float32Array len
      readFormat = "read" +
        if format.float==true then "Float"+format.endianness
        else if format.bitDepth==8 then 'Int8'
        else
          (if format.signed then "Int" else "Uint") +
          format.bitDepth + format.endianness
      #while i<len-1
      console.log "readFormat: "+readFormat
      toFloat = buildFormula format
      work = (i)->
        (cb)->
          nb = data.buffer.slice i*size, (i+1)*size
          #console.log nb
          res = nb[readFormat]()
          floatArr[i] = if format.float then res else toFloat res
          cb() if cb

      functs = []
      measure 'rest'
      for nr in [0...len] then functs[nr] = work(nr)
      measure 'cr workers'
      for nr in [0...len] then functs[nr]()
      #async.series functs, (res)-> console.log 'DONWDONEEE !!!!!', floatArr
      measure 'mergeBuff'
      #console.log floatArr

    lll: 0
    _write: (data, enc, next) ->
      @lll += data.length
      console.log @lll, enc
      #@mergeBufferToType new DataView data
      #channels = @toStereoBuffers data
      #channels.forEach (v,i)=> channels[i] = @mergeBufferToType channels[i]
      #@result.push channels
      next()

  # audioFormat: 3
  # bitDepth: 32
  # blockAlign: 4
  # byteRate: 176400
  # channels: 1
  # endianness: "LE"
  # float: true
  # sampleRate: 44100
  # signed: true

  # # demoFormat
  # audioFormat: 1
  # bitDepth: 16
  # blockAlign: 4
  # byteRate: 176400
  # channels: 2
  # endianness: "LE"
  # sampleRate: 44100
  # signed: true

  # audioFormat: 1
  # bitDepth: 8
  # blockAlign: 2
  # byteRate: 88200
  # channels: 2
  # endianness: "LE"
  # sampleRate: 44100
  # signed: false
