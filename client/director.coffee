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

  stop: ->
    @frameState = 0
    @pageState = 0
    @screenplay.forEach (page)->
      page.looped = undefined
      page.init()
    @assignPage()

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
          @screenplay.forEach (page)-> page.looped = undefined
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
    console.log @screenplay
    @currentPage = @screenplay[@pageState]
    @nextPage = @screenplay[(@pageState+1)%@screenplay.length]
    if !@currentPage.draw? then @currentPage.draw = @currentPage.init()
    #console.log "change task "+@pageState#, @currentPage, @nextPage
