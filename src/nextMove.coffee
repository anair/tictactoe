NextMove = (gameMatrix, lastAdded) ->
    this.gameMatrix = gameMatrix
    this.lastAdded = lastAdded
    this.x = 0
    this.o = 0

NextMove.prototype.compareWith = (move, state) ->
    # Compare this move to the one passed in, and return 
    # the best option for the give state
    if not move? then return this

    toggledState = GameUtils.toggleState state

    if this[state] isnt 0
        if move[state] is 0 then return this

        moveScore = move[state]/(move[state] + move[toggledState])
        thisScore = this[state]/(this[state] + this[toggledState])

        # Return the move that has the higher probabilty of winning
        if thisScore > moveScore then return this
    else
        if move[state] isnt 0 then return move
        if move[toggledState] > this[toggledState]
            return this

    return move

