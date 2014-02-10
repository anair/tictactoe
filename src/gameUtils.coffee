GameUtils = ( ->

    self = {}

    self.clickableClass = "clickable"
    self.oClass = ".fa-circle-o"
    self.xClass = ".fa-times"

    self.nextToPlay = "x"
    self.matrix = null
    self.lastAdded = null

    self.playerRole = "x"
    self.aiRole = "o"

    self.moves = []

    self.initGameMatrix = ->
        self.matrix = new GameMatrix()
        self.matrix.initClickHandlers()
        self.initGameFromUrl()
        
        $(window).bind 'hashchange', (e) ->
            self.parseUrl()

        return

    self.resetGameMatrix = ->
        if self.matrix? then self.matrix.reset()
        self.matrix = new GameMatrix()
        self.matrix.initClickHandlers()
        return

    self.toggleNextToPlay = ->
        if self.nextToPlay is "o"
            self.nextToPlay = "x"
        else
            self.nextToPlay = "o"

    self.toggleState = (state) ->
        if state is "o" then return "x"
        if state is "x" then return "o"
        return null


    self.plotWinner = ->
        if self.matrix?
            winners = self.matrix.getWinners()
            
            if winners?
                for winner in winners
                    winner.markWinner()

                self.matrix.removeClickHandlers()

        return winners


    self.replay = (move) ->
        console.log move

        if not move?.length? or move.length < 4
            return

        x = move.charAt 1
        y = move.charAt 3

        if x <= 2 and y <= 2
            square = self.matrix.matrix[x][y]
            square.aiClick()


        if move.length is 8
            x = move.charAt 5
            y = move.charAt 7

            if x <= 2 and y <= 2
                square = self.matrix.matrix[x][y]
                square.aiClick()

    self.popMoves = (newLength) ->
        if not newLength? or newLength >= self.moves.length
            return

        totalElementsToPop = self.moves.length - newLength
        for i in [0..totalElementsToPop - 1]
            move = self.moves.pop()
            move.square.reset()
            move.square.initClickHandler()

            if move.aiSquare?
                move.aiSquare.reset()
                move.aiSquare.initClickHandler()
            else
                self.toggleNextToPlay()

        if totalElementsToPop > 0
            self.matrix.unmarkWinners()

        return

    self.pushMove = (square, aiSquare) ->
        if not square?
            return

        x = square.x
        y = square.y
        url = "x#{x}y#{y}"

        if aiSquare?
            x = aiSquare.x
            y = aiSquare.y
            url += "x#{x}y#{y}"

        self.moves.push  {
            square: square
            aiSquare: aiSquare
            url : url
        }

        location.hash = location.hash + "/" + url
        return

    self.parseUrl = ->
        locationHash = location.hash
        if not locationHash? or locationHash is ""
            self.popMoves 0
            return 
        locationHash = locationHash.substring(2)
        newMoves = locationHash.split "/"


        # Check if the internal stack and the url matches up
        mismatch = false
        for i in [0..newMoves.length - 1]
            newPlayerMove = newMoves[i]
            if i < self.moves.length
                exisitingPlayerMove = self.moves[i]
                if exisitingPlayerMove.url isnt newPlayerMove
                    mismatch = true
                    break

        # If the move stacks do not align up, replay the entire game
        if mismatch
            self.resetGameMatrix()
            for newMove in newMoves
                self.replay newMove
            return

        # If there are more moves on the stack than in the url then
        # rewind the game
        if newMoves.length < self.moves.length
            self.popMoves newMoves.length

        # Otherwise forward the game
        else
            for i in [self.moves.length..newMoves.length]
                self.replay newMoves[i - 1]

    
    self.initGameFromUrl = ->
        locationHash = location.hash
        if not locationHash? or locationHash is ""
            return
        locationHash = locationHash.substring(2)
        newMoves = locationHash.split "/"

        for newMove in newMoves
                self.replay newMove

    return self

)()