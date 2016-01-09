fft = require('fft-js').fft
fftUtil = require('fft-js').util
toBuffer = require('typedarray-to-buffer')

findNextPow2 = (nr)->
  pow = 1
  while nr>=Math.pow(2, pow) then pow++
  Math.pow 2, pow-1

getFft = (signal)->
  signal = signal.slice 0, findNextPow2 signal.length
  phasors = fft signal
  freq = toBuffer new Uint16Array fftUtil.fftFreq phasors, 44100
  magn = toBuffer new Uint16Array fftUtil.fftMag phasors
  Buffer.concat [freq, magn], freq.length + magn.length

process.on 'message', (data)->
  data = new Buffer data
  res = getFft new Uint8Array data
  process.send res

endEvent = ->
  process.exit()
