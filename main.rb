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
    
    # Array of arrays to store the pieces of the games
    attr_reader :canvas    

    # Initialize a board gien two integers (size)
    def initialize(rows, columns)
        @canvas = Array.new(rows) { Array.new(columns) }
        @columns = generate_columns()
    end
    
    # Print a friendly reperesenation of the canvas for the user
    def show
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
    
    # Check for a valid general coordinates
    def valid_coordinates?(row,col)
        # Convert the col value to downcase
        col = col.downcase()

        return false if row > @canvas.length
        return false if row < 1
        return false if !@columns.find_index(col)
        return true
    end
    
    # Gen the length of the canvas from board object
    def length
       return @canvas.length
    end
    
    # Check if the cell of a canvas given a row and col is empty
    def empty_cell?(row,col)
        return false if @canvas[row][col] != nil
        true    
    end
    
    # Add a piece to canvas
    def add(object,row,col)
        @canvas[row][col] = object
        return true
    end
    
    private
    
    # Array of letters for the Y axis
    attr_reader :columns
    
    # Generate an array of alphabet of the size of columns
    def generate_columns()
        alp = ("a".."z").to_a
        return alp[0,@canvas.length]
    end
   
end

# General piece class
class Piece

    # Initialize a piece
    def initialize(player, name, mark)
        @player = player
        @name = name
        @mark = mark
    end
    
    # Value or symbol to show to players
    attr_reader :mark
end 

# General player class
class Player
    # Name of the player
    attr_reader :name
    
    # Initialize a player
    def initialize(game,name)
        @game = game
        @name = name
    end

    # Ask for a valid coordinates from a the board
    def select_position(piece)
        coordinates = nil
        
        # Get coordinates from players
        loop do
            puts "Player #{@name}"
            puts "Insert the row (number): "
            x = gets.chomp.to_i
            puts "Insert the column (letter): "
            y = gets.chomp
	
            coordinates = @game.convert_position(piece,x,y)
            
            break if !coordinates.nil?
        end
        return coordinates
    end

end

# Game "TicTaeToe" class
class TicTaeToeGame

    # Initialize game "TicTaeToe"
    def initialize()
        @board = Board.new(3,3)
        @name = "TicTaeToe"
        @current_player_id = 0
        @players = [Player.new(self,"X"),Player.new(self,"O")]
    end
    
    private
    
    # Check for one or more empty cells in the board
    def empty_cells?
        @board.canvas.flatten.all?
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
        @board.canvas.each do |row|
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
                p =  @board.canvas[j][i]
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
        if @board.canvas[0][0] and @board.canvas[1][1] and @board.canvas[2][2]
            if @board.canvas[0][0].mark == symbol and @board.canvas[1][1].mark == symbol and @board.canvas[2][2].mark == symbol
                return true
            end
        end 
        if @board.canvas[2][0] and @board.canvas[1][1] and @board.canvas[0][2]
            if @board.canvas[2][0].mark == symbol and @board.canvas[1][1].mark == symbol and @board.canvas[0][2].mark == symbol
                return true
            end
        end
        return false
    end
    
    # Determinate if a player won based on his "symbol"
    def winner?(player)
        return true if check_board_game(player.name)
        return false
    end
    
    # Ask for the mark of the first player
    def ask_player_marks()
        option = nil # Flag to store the "mark" selected by the first player
        
        # Get and validate the "mark" of the first user
        loop do
            puts "Player select your mark: (number)"
            puts "1. X"
            puts "2. O"
            option = gets.chomp.to_i
            break if [1,2].include?(option)
            puts "Invalid option.."
        end
        
        # Assign players based on the first player mark
        @current_player_id = option - 1
    end

    # Place a piece from the player in the board
    def place_player_marker(player,piece)
        coordinates = player.select_position(piece)
        @board.add(piece,coordinates[0],coordinates[1])
    end
    
    # Return the current player
    def current_player()
        return @players[@current_player_id]
    end
    
    # Switch current player id (index)
    def switch_players!
        @current_player_id = 1 - @current_player_id
    end
    
    public 
    
    # Convert positions to a valid positions
    def convert_position(piece,row,col)

        # Validate coordinates from a user perspective
        if !@board.valid_coordinates?(row,col)
           puts "Invalid coordinates!"
           return nil
        end

        # Convert user inputs to valid indexes 
        row = @board.invert_number(@board.length,row)
        col = @board.letter_to_number(col)
     
        # Specific validate to the TicTaeToeGame
        if !@board.empty_cell?(row,col)
           puts "There is a piece here!, try another one"
           return nil
        end
	
        return row,col
    end
    
    # Principal flow of the game
    def game()
        
	# Print the board at the beginning of the game
	@board.show()

        # Ask for the mark of the first player
        ask_player_marks()

        loop do           
            # Create piece based on player info
            player_name = current_player().name
            piece = Piece.new(current_player(),player_name,player_name)
            
            # Place the piece (mark)
            place_player_marker(current_player(), piece)
	    
	    # Print the board
            @board.show()

            # Determinate a winner
            if winner?(current_player())
                puts "Winner " + current_player().name
                return
            # If there is no more empty cells
            elsif empty_cells?
                puts "Tie!"
                return 
            end
            
            # Switch players
            switch_players!
        end
    end
    
end

# Main
game = TicTaeToeGame.new()
game.game()
 
