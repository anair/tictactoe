GameMatrix = ->
    this.matrix = [ [], [], [] ]
    this.winnerState = null
    this.winners = null

    for y in [0..2]
        for x in [0..2]
            this.matrix[x][y] = new Square(x, y)
    return

GameMatrix.prototype.clone = ->
    matrix = [ [], [], [] ]
    for y in [0..2]
        for x in [0..2]
            matrix[x][y] = this.matrix[x][y].clone()
    
    GameMatrix gameMatrix = new GameMatrix()
    gameMatrix.matrix = matrix
    return gameMatrix

GameMatrix.prototype.reset = ->
    for y in [0..2]
        for x in [0..2]
            this.matrix[x][y].reset()
    return

GameMatrix.prototype.unmarkWinners = ->
    for y in [0..2]
        for x in [0..2]
            this.matrix[x][y].unmarkWinner()
            if not this.matrix[x][y].state?
                this.matrix[x][y].removeClickHandler()
                this.matrix[x][y].initClickHandler()
    return

GameMatrix.prototype.initClickHandlers = ->
    for y in [0..2]
        for x in [0..2]
            this.matrix[x][y].initClickHandler()
    return

GameMatrix.prototype.removeClickHandlers = ->
    for y in [0..2]
        for x in [0..2]
            this.matrix[x][y].removeClickHandler()
    return

GameMatrix.prototype.isGameOverInADraw = ->
    for y in [0..2]
        for x in [0..2]
            if not this.matrix[x][y].state?
                return false
    return true

GameMatrix.prototype.getWinningState = ->
    winners = this.getWinners()
    if winners? and winners.length is 3
        winnerState = winners[0].state
        this.winnerState = winnerState
        return winnerState
    return null


GameMatrix.prototype.getTheNextBestMove = (nextState) ->
    nextMoves = this.getNextMoves nextState
    currentBestMove = null
    for nextMove in nextMoves
        currentBestMove = nextMove.compareWith currentBestMove, nextState

    if not currentBestMove? then return null
    return currentBestMove.lastAdded


GameMatrix.prototype.getNextMoves = (nextState) ->
    gameMatrix = this
    matrix = this.matrix
    nextMoves = []

    for y in [0..2]
        for x in [0..2]
            square = matrix[x][y]
            if not square.state?
                clonedGameMatrix = gameMatrix.clone()
                nextMove = new NextMove clonedGameMatrix, clonedGameMatrix.matrix[x][y]
                nextMove.lastAdded.state = nextState
                nextMoves.push nextMove

                # If this is a winning move, then all the other moves don't matter..
                winningState = nextMove.gameMatrix.getWinningState()
                if winningState?

                    if winningState is "x"
                        nextMove.x = 1
                        nextMove.o = 0
                        return [nextMove]
                    else
                        nextMove.x = 0
                        nextMove.o = 1
                        return [nextMove]
                else
                    nextMoveResults = nextMove.gameMatrix.getNextMoves(GameUtils.toggleState(nextState))

                    x = 0
                    o = 0
                    for nextMoveResult in nextMoveResults
                        # For each level you go deeper, the weight of a win halves
                        x = nextMoveResult.x/2 + x
                        o = nextMoveResult.o/2 + o

                    nextMove.x = x
                    nextMove.o = o

    return nextMoves

GameMatrix.prototype.getWinners = ->

    isMatch = (square1, square2, square3) ->
        if not square1 or not square2 or not square3 then return false
        if square1.state is "x" and square2.state is "x" and square3.state is "x"
            return true
        if square1.state is "o" and square2.state is "o" and square3.state is "o"
            return true
        return false

    matrix = this.matrix
    winners = null

    if isMatch matrix[0][0], matrix[1][0], matrix[2][0]
        winners = [ 
            matrix[0][0]
            matrix[1][0]
            matrix[2][0]
        ]

    if isMatch matrix[0][0], matrix[0][1], matrix[0][2]
        winners = [ 
            matrix[0][0]
            matrix[0][1]
            matrix[0][2]
        ] 

    if isMatch matrix[0][0], matrix[1][1], matrix[2][2]
        winners = [ 
            matrix[0][0]
            matrix[1][1]
            matrix[2][2]
        ] 

    if isMatch matrix[2][2], matrix[2][1], matrix[2][0]
        winners = [ 
            matrix[2][2]
            matrix[2][1]
            matrix[2][0]
        ]

    if isMatch matrix[2][2], matrix[1][2], matrix[0][2]
        winners = [ 
            matrix[2][2]
            matrix[1][2]
            matrix[0][2]
        ]

    if isMatch matrix[0][2], matrix[1][1], matrix[2][0]
        winners = [ 
            matrix[0][2]
            matrix[1][1]
            matrix[2][0]
        ]

    if isMatch matrix[1][0], matrix[1][1], matrix[1][2]
        winners = [ 
            matrix[1][0]
            matrix[1][1]
            matrix[1][2]
        ]

    if isMatch matrix[0][1], matrix[1][1], matrix[2][1]
        winners = [ 
            matrix[0][1]
            matrix[1][1]
            matrix[2][1]
        ]

    this.winners = winners
    return winners
