# General functions to convert or interpret values from user to workable inputs
module Functions
    # Convert one letter to a number (alphabetically)
    def letter_to_number(letter)
        alp = ("a".."z").to_a
        return alp.index(letter)
    end

    # Invert the number given by a valid index from 0 to max
    def invert_number(max,number)
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
        @columns = generate_columns()
    end
    
    # Generate an array of alphabet of the size of columns
    def generate_columns()
        alp = ("a".."z").to_a
        return alp[0,@canvas.length]
    end

    # Display a friendly reperesenation of the canvas for the user
    def display
        puts "    a   b   c"
        puts "  -------------"
        i = @canvas.length 
        @canvas.each do |row|
            print "#{i} | "
            row.each do |element|
                cell = element ? element.mark : " "
                print "#{cell} | "
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
        if !valid_coordinates?(row,col)
           puts "Invalid coordinates!"
           return false
        end
        
        # Convert user inputs to valid indexes 
        row = invert_number(@canvas.length,row)
        col = letter_to_number(col)        
        
        if !empty_cell?(row,col)
           puts "There is a piece here!, try another one"
           return false
        end

        @canvas[row][col] = object
        return true
    end

    # Check if the cell of a canvas given a row and col is empty
    def empty_cell?(row,col)
        return false if @canvas[row][col] != nil
        true    
    end

    # Check for a valid coordinates
    def valid_coordinates?(row,col)
        return false if row > @canvas.length
        return false if row < 1
        return false if !@columns.find_index(col)
        return true
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
    def initialize(player, name, mark)
        @player = player
        @name = name
        @mark = mark
    end
    
    # Value or symbol to display to players
    attr_accessor :mark

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

    # Check for one or more empty cells in the board
    def empty_cells?
        !@canvas.flatten.all?
    end

    # Check for a winner by given symbol ("O" or "X")
    def check_board_game(symbol)
        return true if check_rows(symbol)
        return true if check_columns(symbol)
        return true if check_diagonals(symbol)
        return false
    end

    # Check for a pieces of the same symbol by rows
    def check_rows(symbol)
        counter = 0
        @canvas.each do |row|
            row.each do |p| 
                if p 
                    if p.mark == symbol
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
    def check_columns(symbol)
        counter = 0
        for i in 0..2 do
            for j in 0..2 do
                p =  @canvas[j][i]
                if p
                    if p.mark == symbol
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
    def check_diagonals(symbol)
        if @canvas[0][0] and @canvas[1][1] and @canvas[2][2]
            if @canvas[0][0].mark == symbol and @canvas[1][1].mark == symbol and @canvas[2][2].mark == symbol
                return true
            end
        end 
        if @canvas[2][0] and @canvas[1][1] and @canvas[0][2]
            if @canvas[2][0].mark == symbol and @canvas[1][1].mark == symbol and @canvas[0][2].mark == symbol
                return true
            end
        end
        return false
    end
    
    # Determinate if a player won based on his "symbol"
    def winner?()
        return "X" if check_board_game("X")
        return "O" if check_board_game("O")
        return false
    end

end

# General player class
class Player
    
    attr_accessor :name
    
    # Initialize a player
    def initialize(name)
        @name = name
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
        mark = nil # Flag to store the "mark" selected by the first player
        winner = false 
        msg_player = ""

        # Get and validate the "mark" of the first user
        loop do
            puts "Player select your mark: (number)"
            puts "1. X"
            puts "2. O"
            mark = gets.chomp.to_i
            break if [1,2].include?(mark)
        end

        # Assign player marks given the fisrt selection
        if mark == 1
           player1 = Player.new("X")
           player2 = Player.new("O")
        else
           player1 = Player.new("O")
           player2 = Player.new("X")
        end 

        while @board.empty_cells? do
            x,y = nil, nil

            # Switch beetween player
            if turn
                piece = Piece.new(player1, player1.name, player1.name)
                turn = false
            else
                piece = Piece.new(player2, player2.name, player2.name)
                turn = true
            end
            
            # Get coordinates from players
            loop do
                puts "Player #{piece.mark}"
                puts "Insert the row (number): "
                x = gets.chomp.to_i
                puts "Insert the column (letter): "
                y = gets.chomp

                break if @board.add(piece,x,y)
                
            end

            @board.display()

            # Determinate a winner
            winner = @board.winner?()
            if winner
                puts "Winner " + winner
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
