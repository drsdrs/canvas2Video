{ fork, spawn } = require 'child_process'
fs = require 'fs'
filename = process.argv[2]
frameSize = process.argv[3]

writeStreamCh0 = fs.createWriteStream('.cached/'+filename+'/ch0_raw.dat', 'flags': 'w')
writeStreamCh0Freq = fs.createWriteStream('.cached/'+filename+'/ch0_fft_freq.dat', 'flags': 'w')
writeStreamCh0Magn = fs.createWriteStream('.cached/'+filename+'/ch0_fft_magn.dat', 'flags': 'w')
writeStreamCh1 = fs.createWriteStream('.cached/'+filename+'/ch1_raw.dat', 'flags': 'w')
writeStreamCh1Freq = fs.createWriteStream('.cached/'+filename+'/ch1_fft_freq.dat', 'flags': 'w')
writeStreamCh1Magn = fs.createWriteStream('.cached/'+filename+'/ch1_fft_magn.dat', 'flags': 'w')

fs.writeFile '.cached/'+filename+'/frameSize.dat', frameSize+''

init = ->
  chunkCh0Rest = new Buffer 0
  chunkCh1Rest = new Buffer 0
  sendFftPackageCount = 0

  fftCh0Cnt = 0
  fftCh1Cnt = 0

  fftCh0 = fork __dirname+'/streamRaw2Fft.coffee'
  fftCh1 = fork __dirname+'/streamRaw2Fft.coffee'

  # Extract unsigned 8-bit PCM data with ffmpeg
  ffmpeg = spawn 'ffmpeg', [
    '-i', filename
    '-f', 'u8'
    '-ac', '2'
    '-acodec', 'pcm_u8'
    '-ar', '44100'
    '-y', 'pipe:1'
  ]

  ffmpeg.stdout.on 'data', (d)->
    len = d.length
    i = 0
    j = 0
    chunkCh0 = new Buffer len/2
    chunkCh1 = new Buffer len/2
    while i<len # map channels
      chunkCh0[j] = d[i]
      chunkCh1[j] = d[i+1]
      i+=2
      j++
    writeStreamCh0.write chunkCh0
    writeStreamCh1.write chunkCh1
    fftBlock0 = Buffer.concat [chunkCh0, chunkCh0Rest], chunkCh0.length+chunkCh0Rest.length
    fftBlock1 = Buffer.concat [chunkCh1, chunkCh1Rest], chunkCh1.length+chunkCh1Rest.length
    while fftBlock0.length>frameSize
      fftCh0.send fftBlock0.slice 0, frameSize
      fftCh1.send fftBlock1.slice 0, frameSize
      fftBlock0 = fftBlock0.slice frameSize, fftBlock0.length
      fftBlock1 = fftBlock1.slice frameSize, fftBlock1.length
      sendFftPackageCount++
    chunkCh0Rest = fftBlock0
    chunkCh1Rest = fftBlock1


  ffmpeg.stderr.on 'data', (data) ->
    null#console.log 'ffmpeg ERR '+data

  ffmpeg.stderr.on 'end', (data)->
    writeStreamCh0.end()
    writeStreamCh1.end()
    console.log 'ffmpeg read wav is done'



  checkFftProgress = ->
    console.log parseInt(fftCh0Cnt/sendFftPackageCount*100)+"% "+parseInt(fftCh1Cnt/sendFftPackageCount*100)+"%"
    if fftCh0Cnt==sendFftPackageCount && fftCh1Cnt==sendFftPackageCount
      process.send 'all is done'
      process.exit()

  fftCh0.on 'message', (data)->
    data = new Buffer data
    if fftCh0Cnt==0
      fs.writeFile '.cached/'+filename+'/fftSize.dat', data.length/4+''
    writeStreamCh0Freq.write data.slice 0, data.length/2
    writeStreamCh0Magn.write data.slice data.length/2, data.length
    fftCh0Cnt++
    checkFftProgress()

  fftCh1.on 'message', (data)->
    data = new Buffer data
    writeStreamCh1Freq.write data.slice 0, data.length/2
    writeStreamCh1Magn.write data.slice data.length/2, data.length
    fftCh1Cnt++
    checkFftProgress()


init()
