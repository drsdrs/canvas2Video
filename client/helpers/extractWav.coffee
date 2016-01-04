# some content from https://gist.github.com/jhurliman/1953894

{ spawn } = require 'child_process'
config = require '../../config'
{measure} = require './measure'
async = require 'async'
fft = require('fft-js').fft
fftUtil = require('fft-js').util
fs = require 'fs'
jsonpack = require 'jsonpack'
caching = false

checkIfCached = ()-> fs.existsSync(config.audioFile+'.dat') && caching


init = (cb)->
  if checkIfCached()
    res = JSON.parse fs.readFileSync config.audioFile+'.dat'
    return cb res

  chData = [ [], [] ]
  saveSample = (smpl, ch)-> chData[ch].push smpl
  readWavFinish = (err, res)->
    if err then throw err# else console.log res
    newData = []
    functs = []
    processChannels = (arrData, channel)->
      assign = (res, channel)-> newData[channel] = res
      toFrames (new Uint8Array arrData), assign, channel

    chData.forEach (data, ch)-> processChannels data, ch
    measure(' start audioProcessing ')
    #saveJsonObject newData
    cb newData
    measure(' end async audioProcess')


  getWav false, saveSample, readWavFinish

module.exports = init

saveJsonObject = (obj)->
  json = jsonpack.JSON.stringify obj
  packedData = jsonpack.pack(json)
  fs.writeFile config.audioFile+'.dat', json
  fs.writeFile config.audioFile+'.dat.txt', packedData


findNextPow2 = (nr)->
  pow = 1
  while nr>Math.pow(2, pow) then pow++
  Math.pow 2, pow-1

getFft = (signal)->
  signal = signal.slice 0, findNextPow2 signal.length
  #signal = Array.prototype.slice.call(signal)
  phasors = fft(signal)
  frequencies = fftUtil.fftFreq(phasors, 44100)
  magnitudes = fftUtil.fftMag(phasors)
  res = frequencies.map (f, ix) ->
    frequency: f
    magnitude: magnitudes[ix]

merge = (data)->
  res = 0
  len = data.length
  i = 0
  while i<len then res += data[i++]
  res/len

toFrames = (data, assign, channel, cb)->
  #console.log 'convert channel'+channel
  waveFrames = []
  waveFramePos = 0
  samplesPerFrame = 44100/config.FPS
  samplesPerFrame = samplesPerFrame-(samplesPerFrame%2)
  samplesToThrowAway = Math.round samplesPerFrame%2
  console.log samplesPerFrame%2
  samplePos = 0
  functs = []
  while samplePos<data.length
    frameData = data.slice samplePos, samplesPerFrame+samplePos
    waveFrames[waveFramePos] =
      data: frameData
      merged: merge frameData
      #fft: getFft frameData
    waveFramePos++
    samplePos += samplesPerFrame+samplesToThrowAway
  assign waveFrames, channel, cb

getWav = (toFloat, sampleCallback, endCallback)->
  outputStr = ''
  oddByte = null
  channel = 0
  gotData = false
  # Extract signed 16-bit little endian PCM data with ffmpeg and pipe to STDOUT
  ffmpeg = spawn 'ffmpeg', [
    '-i', config.audioFile
    '-f', if toFloat then 's16le' else 'u8'
    '-ac', '2'
    '-acodec', if toFloat then 'pcm_s16le' else 'pcm_u8'
    '-ar', '44100'
    '-y', 'pipe:1'
  ]

  ffmpeg.stdout.on 'data', (data) ->
    if toFloat
      gotData = true
      i = 0
      samples = Math.floor((data.length + (if oddByte != null then 1 else 0)) / 2)
      # If there is a leftover byte from the previous block, combine it with the
      # first byte from this block
      if oddByte != null
        value = (data.readInt8(i++) << 8 | oddByte) / 32767
        sampleCallback value, channel
        channel = ++channel % 2
      while i < data.length
        value = data.readInt16LE(i) / 32767
        sampleCallback value, channel
        channel = ++channel % 2
        i += 2
      oddByte = if i < data.length then data.readUInt8(i) else null
    else # to byte
      gotData = true
      i = 0
      while i < data.length
        sampleCallback data[i], channel
        channel = ++channel % 2
        i++

  ffmpeg.stderr.on 'data', (data) ->
    outputStr += data.toString()

  ffmpeg.stderr.on 'end', ->
    if gotData then endCallback null, outputStr
    else endCallback outputStr, null
