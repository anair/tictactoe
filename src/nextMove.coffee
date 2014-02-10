NextMove = (gameMatrix, lastAdded) ->
    this.gameMatrix = gameMatrix
    this.lastAdded = lastAdded
    this.x = 0
    this.o = 0

NextMove.prototype.compareWith = (anotherMove, state) ->
    if not anotherMove? then return this

    toggledState = GameUtils.toggleState state
    if this[state] isnt 0
        currentScore = anotherMove[toggledState]/anotherMove[state]
        thisScore = this[toggledState]/this[state]
        if thisScore < currentScore then return this
    else
        if anotherMove[toggledState] > this[toggledState]
            return this

    return anotherMove

