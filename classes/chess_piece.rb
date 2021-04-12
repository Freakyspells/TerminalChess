# frozen_string_literal: true

class ChessPiece
    attr :position
    attr_reader :colour

    def initialize(position, colour)
        @position = position
        @colour = colour
        @unmoved = true
        @can_jump = false
    end

    def move(row, column)
        if check_valid(row, column)
            @position = [row, column]
            @unmoved = false
            true
        end
    end

    def can_move(start, finish)
        x1 = start[0]
        x2 = finish[0]
        y1 = start[1]
        y2 = finish[1]

        # x or y axis only? OR diagnoal x diff == y diff (Makes sure we're only moving in a straight line)
        if (x1 == x2 || y1 == y2) || (x1 - x2).abs == (y1 - y2).abs
            return true
        else
            return false
        end
    end

    def check_valid(row, column)
        # Don't move if you have a piece in the space position.

        
    end
    
    def can_jump
        puts "trying to jump"
        return @can_jump
    end
    # def inspect
    #     "#{@type}, #{@position} & #{@colour}"
    # end
    def inspect
        @type
        # "test"
    end

    def to_s
        @type
    end
end

class Pawn < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = "  Pawn  #{@postion}"
    end

    def move(row, column)
        if check_valid(row, column)
            super(row, column)
            puts row
            if row == 0 && @colour == 'white' || row == 7 && @colour == 'black'
                @type = " Queen "
                Queen.new(@position, colour)
            end
            return true
        else
            return false
        end
    end

    def check_valid(row, column)
        if @colour == 'white' && row < @position[0] || @colour == 'black' && row > @position[0]
            if @position[1] == column
                return true
            end
        end
        return false
    end
end

class Castle < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = ' Castle '
    end
end

class Knight < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = ' knight '
        @can_jump = true
    end
    def can_move(start, finish)
        x_diff = (start[0] - finish[0]).abs
        y_diff = (start[1] - finish[1]).abs
        x_diff + y_diff == 3 && x_diff == 1 || y_diff == 1 ? true : false
    end
end

class Bishop < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = ' Bishop '
    end
end

class Queen < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = ' Queen  '
    end
end

class King < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = '  King  '
    end
end
