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

class TicTaeToe
    def initialize()
        @board = Board.new(3,3)
        @name = "TicTaeToe"
    end
    
    def game()
        piece = Piece.new("Player1", "X", "X")
        @board.add(piece,0,0)
        @board.display()
    end
    
end

game = TicTaeToe.new()
game.game()
