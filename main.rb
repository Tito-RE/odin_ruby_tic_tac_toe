module Functions
    # Convert one letter to a number (alphabetically)
    def letterToNumber(letter)
        alp = ("a".."z").to_a
        return alp.index(letter)
    end  
end 

class Board
    include Functions    

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
        col = letterToNumber(col)
        if !validCoordinates?(row,col)
           puts "Invalid coordinates!"
           return false
        end
        if !emptyCell?(row,col)
           puts "There is a piece here!, try another one"
           return false
        end
        @canvas[row][col] = object
        return true
    end

    def emptyCell?(row,col)
        return false if @canvas[row][col] != nil
        true    
    end

    # Check for a valid coordinates
    def validCoordinates?(row,col)
        return false if row == nil
        return false if col == nil
        return false if row >= @canvas.length
        return false if row <= 0
        return false if col >= @canvas[0].length
        return true
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
            if @canvas[0][0].alias_to_display == symbol and @canvas[1][1].alias_to_display == symbol and @canvas[2][2].alias_to_display == symbol
                return true
            end
        end 
        if @canvas[2][0] and @canvas[1][1] and @canvas[0][2]
            if @canvas[2][0].alias_to_display == symbol and @canvas[1][1].alias_to_display == symbol and @canvas[0][2].alias_to_display == symbol
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
        @board.display()
        turn = true
        while @board.empty_cells? do
            x,y = nil, nil 
            if turn
                piece = Piece.new("Player1", "X", "X")
                turn = false
            else
                piece = Piece.new("Player2", "O", "O")
                turn = true
            end

            loop do 
                puts "Insert the row (number): "
                x = gets.chomp.to_i
                x -= 1
                puts "Insert the column (letter): "
                y = gets.chomp

                break if @board.add(piece,x,y)
                
            end

            @board.display()

            
            if @board.checkBoardGame("X")
                puts "Winner X"
                break
            end
            if @board.checkBoardGame("O")
                puts "Winner O"
                break
            end
        end
    end

end


game = TicTaeToeGame.new()
game.game()
