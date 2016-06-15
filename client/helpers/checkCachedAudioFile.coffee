fs = require 'fs'
{ fork } = require 'child_process'
config = require '../../config'
filename = if config.audioFile.length? then config.audioFile.split('/').pop() else false
caching = config.caching
frameSize = 44100 / config.FPS


init = (cb)->
  filesReady = ()->
    if filename
      loadAudioData makeFrameData, cb
    else return cb()
  fs.exists '.cached/'+filename, (exist)->
    return filesReady() if exist && caching && checkPackageSize()
    fs.mkdir '.cached/'+filename, ()->
      forkung = fork __dirname+'/processWav.coffee', [ filename, frameSize ]
      forkung.on 'message', (data)-> filesReady()

module.exports = init

checkPackageSize = ()->
  fs.readFileSync('.cached/'+filename+'/frameSize.dat')+''==frameSize+''

spliceToFrameArray = (data)->
  fftSize = fs.readFileSync('.cached/'+filename+'/fftSize.dat')+''
  rawPos = 0
  fftPos = 0
  i = 0
  resArr = []
  len = data.raw.length/frameSize
  while i<len-1
    raw = data.raw.slice i*frameSize, (i+1)*frameSize
    freq = data.fftFreq.slice i*fftSize, (i+1)*fftSize
    magn = data.fftMagn.slice i*fftSize, (i+1)*fftSize
    resArr[i] =
      raw: raw
      fft: { freq: freq, magn: magn }
    i++
  resArr

buffer2Uint16 = (buf)->
  trg = new Uint16Array buf.length/2
  len = buf.length/2
  i = 0
  while i<len
    trg[i] = buf.readUInt16LE(i*2)
    i++
  trg

makeFrameData = (audioData, cb)->
  l = spliceToFrameArray audioData[0]
  r = spliceToFrameArray audioData[1]
  cb [ l, r ]

loadAudioData = (cb, endCb)->
  audioData = [ {}, {} ]
  fileCnt = 6
  checkFileCnt = ()->
    if --fileCnt==0 then cb audioData, endCb

  fs.readFile '.cached/'+filename+'/ch0_raw.dat', (err, res)->
    audioData[0].raw = new Uint8Array res
    checkFileCnt()

  fs.readFile '.cached/'+filename+'/ch1_raw.dat', (err, res)->
    audioData[1].raw = new Uint8Array res
    checkFileCnt()

  fs.readFile '.cached/'+filename+'/ch0_fft_freq.dat', (err, res)->
    audioData[0].fftFreq = buffer2Uint16 res
    checkFileCnt()

  fs.readFile '.cached/'+filename+'/ch1_fft_freq.dat', (err, res)->
    audioData[1].fftFreq = buffer2Uint16 res
    checkFileCnt()

  fs.readFile '.cached/'+filename+'/ch0_fft_magn.dat', (err, res)->
    audioData[0].fftMagn = buffer2Uint16 res
    checkFileCnt()

  fs.readFile '.cached/'+filename+'/ch1_fft_magn.dat', (err, res)->
    audioData[1].fftMagn = buffer2Uint16 res
    checkFileCnt()
