# frozen_string_literal: true

class ChessPiece
    attr :position
    attr_reader :colour, :can_jump

    def initialize(position, colour)
        @position = position
        @colour = colour
        @unmoved = true
        @can_jump = false
    end

    def move(row, column)
        @unmoved = false
        true
    end

    def can_move(start, finish)
        x1 = start[0]
        x2 = finish[0]
        y1 = start[1]
        y2 = finish[1]

        # x or y axis only? OR diagonal x diff == y diff (Makes sure we're only moving in a straight line)
        (x1 == x2 || y1 == y2) || (x1 - x2).abs == (y1 - y2).abs ? true : false
    end

    def inspect
        @type
    end

    def to_s
        @type
    end
end

class Pawn < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = "  Pawn  "
    end

end

class Castle < ChessPiece
    def initialize(position, colour)
        super(position, colour)
        @type = ' Castle '
    end

    def can_move(start, finish)
        x1 = start[0]
        x2 = finish[0]
        y1 = start[1]
        y2 = finish[1]

        # x or y axis only? OR diagonal x diff == y diff (Makes sure we're only moving in a straight line)
        x1 == x2 || y1 == y2 ? true : false
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

    def can_move(start, finish)
        puts "checking bishop"
        p start
        p finish
        p x1 = start[0]
        p x2 = finish[0]
        p y1 = start[1]
        p y2 = finish[1]

        # diagonal only: x diff == y diff 
        (x1 - x2).abs == (y1 - y2).abs ? true : false
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
