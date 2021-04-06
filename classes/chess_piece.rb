# frozen_string_literal: true

class ChessPiece
    attr :position
    attr_reader :colour

    def initialize(position, colour)
        @position = position
        @colour = colour
        @unmoved = true
    end

    def move(row, column)
        @position = [row, column]
        @unmoved = false
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
        super(row, column)
        puts row
        if row == 0 && @colour == 'white' || row == 7 && @colour == 'black'
            @type = " Queen "
        end
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
