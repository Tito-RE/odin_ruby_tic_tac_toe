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
                    print element
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

board = Board.new(3,3)
board.add("X",0,0)
board.add("O",1,1)
board.add("X",2,2)

board.display
