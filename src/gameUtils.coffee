GameUtils = ( ->

    self = {}

    self.clickableClass = "clickable"
    self.oClass = ".fa-circle-o"
    self.xClass = ".fa-times"

    self.nextToPlay = "o"
    self.matrix = null
    self.lastAdded = null

    self.initGameMatrix = ->
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

    return self

)()