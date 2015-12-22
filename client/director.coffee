module.exports =
  pageState: 0
  frameState: 0
  currentPage: null
  nextPage: null
  screenplay: null
  fps: 24
  init: (screenplay, fps)->
    if fps then @fps = fps
    @screenplay = screenplay
    @assignPage()
    @pageState = 1
  direct: ->
    if @checkPage()
      @drawPage()
      true
    else false
  checkPage: ->
    if @nextPage.time*@fps<=@frameState
      @frameState++
      if @currentPage.end?
        if @currentPage.loop
          @pageState = 0
          @frameState = 0
          @screenplay.forEach (page, i)-> page.looped = undefined
        else return false
      @assignPage()
      @pageState++
    true
  drawPage: ->
    if @currentPage.loop then @currentPage.draw()
    else if !@currentPage.looped?
      @currentPage.looped = true
      @currentPage.draw()
    @frameState++
  assignPage: ->
    @currentPage = @screenplay[@pageState]
    @nextPage = @screenplay[(@pageState+1)%@screenplay.length]
    @currentPage.draw = @currentPage.init()
    #console.log "change task "+@pageState#, @currentPage, @nextPage
