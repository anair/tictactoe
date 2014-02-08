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
    this.aiClick()
    setTimeout ->
        square = GameUtils.matrix.getTheNextBestMove(GameUtils.nextToPlay)
        if square?
            console.log square
            square = GameUtils.matrix.matrix[square.x][square.y]
            square.aiClick()
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
    this.getElement().on "click", ->
        self.click()

Square.prototype.markWinner = ->
    this.getElement().addClass "winner"