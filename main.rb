class Board
  
    def initialize(rows, columns)
        @canvas = Array.new(rows) { Array.new(columns) }
    end

    def display
        puts "    a   b   c"
        puts "  -------------"
        i = 1
        @canvas.each do |row|
            print i
            print " | "
            row.each do |element|
                if element
                    print element.alias_to_display
                else
                    print " "
                end
                print " | "
            end
            puts ""
            puts "  -------------"
	    i += 1
        end
    end

    def add(object,row,col)
        @canvas[row][col] = object
    end

    def clean
        @canvas = []
    end

    private
  
    attr_accessor :canvas
end

class Piece

    def initialize(player, name, alias_to_display)
        @player = player
        @name = name
        @alias_to_display = alias_to_display
    end

#    protected
    
    attr_accessor :alias_to_display

    private

    attr_accessor :player, :name
end 

class TicTaeToeBoard < Board
    def initialize(rows,columns)
        super
        @name = "TicTaeToe"
    end

    def empty_cells?
        !@canvas.flatten.all?
    end

    def checkBoardGame(symbol)
        return true if checkRows(symbol)
        return true if checkColumns(symbol)
        return true if checkDiagonals(symbol)
        return false
    end

    # Check for a pieces of the same symbol by rows
    def checkRows(symbol)
        counter = 0
        @canvas.each do |row|
            row.each do |p| 
                if p 
                    if p.alias_to_display == symbol
                        counter += 1     
                    end
                end
            end
            return true if counter == 3
            counter = 0 
        end
        return false
    end

    # Check for a pieces of the same symbol by columns
    def checkColumns(symbol)
        counter = 0
        for i in 0..2 do
            for j in 0..2 do
                p =  @canvas[j][i]
                if p
                    if p.alias_to_display == symbol
                        counter += 1
                    end
                end
            end
            return true if counter == 3
            counter = 0
        end
        return false
    end

    # Check for a pieces of the same symbol by diagonals
    def checkDiagonals(symbol)
        if @canvas[0][0] and @canvas[1][1] and @canvas[2][2]
            if @canvas[0][0].alias_to_display and @canvas[1][1].alias_to_display and @canvas[2][2].alias_to_display
                return true
            end
        end 
        if @canvas[2][0] and @canvas[1][1] and @canvas[0][2]
            if @canvas[2][0].alias_to_display and @canvas[1][1].alias_to_display and @canvas[0][2].alias_to_display
                puts "TRU"
                return true
            end
        end
        return false
    end
end

class TicTaeToeGame
    def initialize()
        @board = TicTaeToeBoard.new(3,3)
        @name = "TicTaeToe"
    end
    
    def game()
        while @board.empty_cells? do
            puts "Insert the row: "
            x = gets.chomp.to_i
            puts "Insert the column: "
            y = gets.chomp.to_i
            piece = Piece.new("Player1", "X", "X")
            @board.add(piece,x,y)
            @board.display()

            # WIP 
            if @board.checkBoardGame("X")
                puts "Winner X"
                break
            end
        end
    end

    def getGameStatus()
        # detect when game over or game in proccess
        @board.flatten.any?
    end    

    def getWinnerPlayer()
        # detect if a player win 
    end

end


game = TicTaeToeGame.new()
game.game()
