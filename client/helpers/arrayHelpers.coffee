module.exports =
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
