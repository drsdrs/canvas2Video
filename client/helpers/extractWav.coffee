# copied from https://gist.github.com/jhurliman/1953894

{ spawn } = require 'child_process'
config = require '../../config'
{measure} = require './measure'
async = require 'async'
fft = require('fft-js').fft
fftUtil = require('fft-js').util

getFft = (signal)->
  signal = signal.slice 0, 512
  #signal = Array.prototype.slice.call(signal)
  phasors = fft(signal)
  frequencies = fftUtil.fftFreq(phasors, 8000)
  magnitudes = fftUtil.fftMag(phasors)
  frequencies.map (f, ix) ->
      frequency: f
      magnitude: magnitudes[ix]



init = (cb)->
  data = [ [], [] ]
  saveSample = (smpl, ch)-> data[ch].push smpl
  readWavFinish = (err, res)->
    if err then throw err# else console.log res
    newData = []
    data.forEach (arrData, i)->
      newData[i] = toFrames new Float32Array arrData
    cb newData

  getWav saveSample, readWavFinish

module.exports = init

merge = (data)->
  res = 0
  len = data.length
  i = 0
  while i<len then res += data[i++]
  res/len

toFrames = (data)->
  waveFrames = []
  waveFramePos = 0
  samplesPerFrame = 44100/config.FPS
  samplesPerFrame = samplesPerFrame-(samplesPerFrame%2)
  samplesToThrowAway = Math.round samplesPerFrame%2
  samplePos = 0
  functs = []
  while samplePos<data.length
    frameData = data.slice samplePos, samplesPerFrame+samplePos
    waveFrames[waveFramePos] =
      data: frameData
      merged: merge frameData
      fft: getFft frameData
    waveFramePos++
    samplePos += samplesPerFrame+samplesToThrowAway
  waveFrames

getWav = (sampleCallback, endCallback)->
  outputStr = ''
  oddByte = null
  channel = 0
  gotData = false
  # Extract signed 16-bit little endian PCM data with ffmpeg and pipe to STDOUT
  ffmpeg = spawn 'ffmpeg', [
    '-i', config.audioFile
    '-f', 's16le'
    '-ac', '2'
    '-acodec', 'pcm_s16le'
    '-ar', '44100'
    '-y', 'pipe:1'
  ]

  ffmpeg.stdout.on 'data', (data) ->
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

  ffmpeg.stderr.on 'data', (data) ->
    # Text info from ffmpeg is output to stderr
    outputStr += data.toString()

  ffmpeg.stderr.on 'end', ->
    if gotData then endCallback null, outputStr
    else endCallback outputStr, null
