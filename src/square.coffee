Square = (x, y)->

    self = this
    self.x = x
    self.y  = y
    self.state = null

    return

Square.prototype.clone = ->
    clonedSquare = new Square this.x, this.y
    clonedSquare.state = this.state
    return clonedSquare

Square.prototype.removeClickHandler = ->
    this.getElement().removeClass GameUtils.clickableClass
    this.getElement().off "click"
    return

Square.prototype.click = ->
    self = this
    if $(GameUtils.gameGridId).hasClass(GameUtils.inProgressClass) then return
    $(GameUtils.gameGridId).addClass GameUtils.inProgressClass

    self.aiClick()
    setTimeout ->
        square = GameUtils.matrix.getTheNextBestMove(GameUtils.nextToPlay)
        if square?
            console.log square
            square = GameUtils.matrix.matrix[square.x][square.y]
            square.aiClick()

        GameUtils.pushMove self, square
        $(GameUtils.gameGridId).removeClass GameUtils.inProgressClass

    , 1000


Square.prototype.aiClick = ->
    $square = this.getElement()
    if $square.hasClass GameUtils.clickableClass
        this.removeClickHandler()
        if GameUtils.nextToPlay is "o"
            
            $square.children(GameUtils.oClass).removeClass "hide"
            GameUtils.toggleNextToPlay()
            this.state = "o"
        else
            
            $square.children(GameUtils.xClass).removeClass "hide"
            GameUtils.toggleNextToPlay()
            this.state = "x"

    GameUtils.plotWinner()


Square.prototype.getElement = ->
    return $("#x#{this.x}y#{this.y}")


Square.prototype.initClickHandler = ->
    self = this
    this.getElement().addClass GameUtils.clickableClass
    this.getElement().on "click", ->
        self.click()

Square.prototype.markWinner = ->
    this.getElement().addClass "winner"

Square.prototype.unmarkWinner = ->
    this.getElement().removeClass "winner"

Square.prototype.reset = ->
    this.removeClickHandler()
    this.state = null
    $square = this.getElement()
    $square.removeClass "winner"
    $square.children(GameUtils.oClass).addClass "hide"
    $square.children(GameUtils.xClass).addClass "hide"
    #$square.addClass GameUtils.clickableClass

