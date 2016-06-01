module.exports =
  smoothArray: (arr, init, smooth)->
    if init? || !@prevArray?
      @prevArray = new Uint16Array arr
      return arr
    else if @prevArray.length!=arr.length
      @prevArray = new Uint16Array arr
      return arr
    arr.forEach (v, i)=>
      arr[i] = (@prevArray[i]*0.75 + arr[i])*0.25
      @prevArray[i] = arr[i]
    arr

  mergeArray: (arr)->
    sum = 0
    arr.forEach (v)-> sum += v
    sum / arr.length

  simplifyArray: (arr, amount)->
    len = Math.round arr.length/amount
    i = 0
    simpleArr = new Uint16Array len
    while i++<len-1
      simpleArr[i] = @mergeArray arr.slice i*amount, (i+1)*amount
      #i++
    simpleArr
