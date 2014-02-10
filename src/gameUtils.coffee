GameUtils = ( ->

    self = {}

    self.clickableClass = "clickable"
    self.oClass = ".fa-circle-o"
    self.xClass = ".fa-times"
    self.inProgressClass = "inProgress"
    self.gameGridId = "#gameGrid"

    self.nextToPlay = "x"
    self.matrix = null
    self.lastAdded = null

    self.playerRole = "x"
    self.aiRole = "o"

    self.moves = []

    self.$backButton = $("#backButton")

    self.initGameMatrix = ->
        self.matrix = new GameMatrix()
        self.matrix.initClickHandlers()
        self.initGameFromUrl()
        
        $(window).bind 'hashchange', (e) ->
            self.parseUrl()


        self.$backButton.on "click", (e) ->
            window.history.back()

        return

    self.resetGameMatrix = ->
        if self.matrix? then self.matrix.reset()
        self.matrix = new GameMatrix()
        self.matrix.initClickHandlers()
        self.moves = []
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


    self.replay = (url) ->
        console.log url

        square = null
        aiSquare = null

        if not url?.length? or url.length < 4
            return

        x = url.charAt 1
        y = url.charAt 3

        if x <= 2 and y <= 2
            square = self.matrix.matrix[x][y]
            square.aiClick()


        if url.length is 8
            x = url.charAt 5
            y = url.charAt 7

            if x <= 2 and y <= 2
                aiSquare = self.matrix.matrix[x][y]
                aiSquare.aiClick()

        self.moves.push  {
            square: square
            aiSquare: aiSquare
            url : url
        }

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

        if self.moves.length is 0
            self.$backButton.addClass "hideButton"
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
        self.$backButton.removeClass "hideButton"
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
        else if newMoves.length > self.moves.length
            for i in [self.moves.length..newMoves.length - 1]
                self.replay newMoves[i]

    
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