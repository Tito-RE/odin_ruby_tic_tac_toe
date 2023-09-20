# General functions to convert or interpret values from user to workable inputs
module Functions
    # Convert one letter to a number (alphabetically)
    def letterToNumber(letter)
        alp = ("a".."z").to_a
        return alp.index(letter)
    end

    # Invert the number given by a valid index from 0 to max
    def invertNumber(max,number)
        inverted = (0..max-1).to_a.reverse
        return inverted[number-1]
    end
end 

# General board class
class Board
    include Functions    

    # Initialize a board gien two integers (size)
    def initialize(rows, columns)
        @canvas = Array.new(rows) { Array.new(columns) }
        @columns = generateColumns()
    end
    
    # Generate an array of alphabet of the size of columns
    def generateColumns()
        alp = ("a".."z").to_a
        return alp[0,@canvas.length]
    end

    # Display a friendly reperesenation of the canvas for the user
    def display
        puts "    a   b   c"
        puts "  -------------"
        i = @canvas.length 
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
	    i -= 1
        end
    end

    # Add a piece to canvas
    def add(object,row,col)
        col = col.downcase()

        # Validate coordinates from a user perspective
        if !validCoordinates?(row,col)
           puts "Invalid coordinates!"
           return false
        end
        
        # Convert user inputs to valid indexes 
        row = invertNumber(@canvas.length,row)
        col = letterToNumber(col)        
        
        if !emptyCell?(row,col)
           puts "There is a piece here!, try another one"
           return false
        end

        @canvas[row][col] = object
        return true
    end

    # Check if the cell of a canvas is empty
    def emptyCell?(row,col)
        return false if @canvas[row][col] != nil
        true    
    end

    # Check for a valid coordinates
    def validCoordinates?(row,col)
        return false if row > @canvas.length
        return false if row < 1
        return false if !@columns.find_index(col)
        return true
    end
    
    # Clean the board
    def clean
        @canvas = []
    end

    # Array of letters for the Y axis
    attr_accessor :columns

    private
  
    # Array of arrays to store the pieces of the games
    attr_accessor :canvas
end

# General piece class
class Piece

    # Initialize a piece
    def initialize(player, name, alias_to_display)
        @player = player
        @name = name
        @alias_to_display = alias_to_display
    end
    
    # Value or symbol to display to players
    attr_accessor :alias_to_display

    private

    # Owner of player and internal name of piece
    attr_accessor :player, :name
end 

# Specific class of the board "TicTaeToe" from Board class
class TicTaeToeBoard < Board

    # Initialize a custom board
    def initialize(rows,columns)
        super
        @name = "TicTaeToe"
    end

    # Check for empty cell in the board
    def empty_cells?
        !@canvas.flatten.all?
    end

    # Check for a winner by given symbol ("O" or "X")
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

# Game "TicTaeToe" class
class TicTaeToeGame

    # Initialize game "TicTaeToe"
    def initialize()
        @board = TicTaeToeBoard.new(3,3)
        @name = "TicTaeToe"
    end
    
    # Principal flow of the game
    def game()
        @board.display()
        turn = true # Flag to switch players 
        mark = nil # Flag to store the "piece" chosen by the user 
        winner = false 
        msg_player = ""

        # Validate the piece chosen by user
        loop do
            puts "Player choose your mark: (number)"
            puts "1. X"
            puts "2. O"
            mark = gets.chomp.to_i
            break if [1,2].include?(mark)
        end

        # Assign player marks given the fisrt selection
        if mark == 1
           p1_name = "X"
           p1_alias = "X"
           p2_name = "O"
           p2_alias = "O"
        else
           p1_name = "O"
           p1_alias = "O"
           p2_name = "X"
           p2_alias = "X"
        end 

        while @board.empty_cells? do
            x,y = nil, nil

            # Switch beetween player
            if turn
                piece = Piece.new("Player1", p1_name, p1_alias)
                msg_player = "Player #{p1_name}"
                turn = false
            else
                piece = Piece.new("Player2", p2_name, p2_alias)
                msg_player = "Player #{p2_name}"
                turn = true
            end
            
            # Get coordinates from players
            loop do
                puts ""
                puts msg_player
                puts "Insert the row (number): "
                x = gets.chomp.to_i
                puts "Insert the column (letter): "
                y = gets.chomp

                break if @board.add(piece,x,y)
                
            end

            @board.display()

            # Determinate a winner
            if @board.checkBoardGame("X")
                puts "Winner X"
                winner = true
                break
            end
            if @board.checkBoardGame("O")
                puts "Winner O"
                winner = true
                break
            end
        end
        # If there is no winner and no more empty cells
        puts "Tie!" if !winner
    end
end

# Main
game = TicTaeToeGame.new()
game.game()
