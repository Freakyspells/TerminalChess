# frozen_string_literal: true
require_relative './chess_piece'

class Board
    attr_reader :board
    def initialize
        @board = create_board
    end

    # initializes my board array with pieces.
    def create_board
        # Create empty board and backline class order
        parts = [Castle, Knight, Bishop, Queen, King, Bishop, Knight, Castle]
        @board = []

        # Setup black side of the board
        @board << (0..7).map { |item| parts[item].new([@board.length, item], "black")}
        @board << (0..7).map { |row| Pawn.new([@board.length, row], "black")}
        
        # adds empty spaces
        while @board.length < 6
            @board << [nil] * 8
            # @board << ['      '] * 8
        end
        
        # Setup white side of the board
        @board << (0..7).map { |row| Pawn.new([@board.length, row], "white")}
        @board << (0..7).map { |item| parts[item].new([@board.length, item], "white")}

        return @board
    end
    
    # Prints the board and the positions
    def print_board
        letters = *('A'..'H')
        letters.map { |letter| print "        " + letter + "   "}
        puts
        for row in 0..7
            print "#{8 - row} "
            for column in 0..7
                if @board[row][column] != nil
                    print "| #{@board[row][column]} |"
                else
                    print '|          |'
                end
                
            end
            print " #{8 - row}"
            # p @board[row]
            puts 
            puts ('============')*8
        end
        letters.map { |letter| print "        " + letter + "   "}
        puts
    end

    def validate_moves(move1, move2)
        validate_move(move1) && validate_move(move2) ? true : false
    end

    def validate_move(move)
        if move.length == 2 && move.ascii_only?
            return ([*'a'..'h'].index move[0].downcase) && ([*1..8].index move[1].to_i) ? true : false
        end
        false
    end

    # takes a position eg a2 and converts it to array position
    def convert_move(move)
        return [8 - move[1].to_i, move[0].downcase.ord-97]
    end

    # moves a piece from 1 square to another
    def move_piece(move1, move2)
        # Change player move to array position
        p position1 = convert_move(move1)
        p position2 = convert_move(move2)
        # Our move starts here
        @piece = @board[position1[0]][position1[1]]
        @finish = @board[position2[0]][position2[1]]
        # This goes to nil after our move is made.
        start_position = position1.dup
        puts "^this is starting finish"
        puts "I should only see this once"
        if valid_move(position1, position2)
            # Update position in piece
            puts "is pawn?"
            p @piece.is_a?(Pawn)
            p @piece.is_a?(Pawn) && (position2[0] == 0 || position2[0] == 7)
            @piece.move
            if @piece.is_a?(Pawn) && (position2[0] == 0 || position2[0] == 7) # If pawn got to the end
                # upgrade it to queen
                @board[position2[0]][position2[1]] = Queen.new(@piece.position, @piece.colour)
            else
                # Move piece to new postion
                @board[position2[0]][position2[1]] = @piece
                @finish = @piece
            end
            @board[start_position[0]][start_position[1]] = nil
            true
        else
            false
        end
    end

    # Checks if a move is valid
    def valid_move(start, finish)
        if @piece == nil || out_of_bounds(start[0], start[1]) || out_of_bounds(finish[0], finish[1]) || attacking_self(@piece.colour)
            return false
        end
        return @piece.can_move(start, finish) && (@piece.can_jump || clear_steps(start, finish)) ? true : false
    end

    def out_of_bounds(row, column)
        if row >= 0 && row <= 7 && column >= 0 && column <= 7
            false
        else
            puts "That is out of bounds."
            true
        end
    end

    def attacking_self(colour)
        p @finish
        if @finish == nil || @finish.colour != colour
            false
        else
            puts "You cannot take your own pieces."
            true
        end
    end

    def clear_steps(start, finish)
        puts "trying steps"
        p ((start[0] - finish[0]).abs > 1)
        p ((start[1] - finish[1]).abs > 1)
        until step_to(finish[0], start[0]) == start[0] && step_to(finish[1], start[1]) == start[1]
            p start
            p finish
            start[0] = step_to(start[0], finish[0])
            start[1] = step_to(start[1], finish[1])
            puts @board[start[0]][start[1]]
            puts "check"
            if @board[start[0]][start[1]] != nil
                puts "This piece cannot jump."
                return false
            end
        end
        puts "Cleared steps."
        true
    end

    def step_to(start, finish)
        if start < finish
            start += 1
        elsif start > finish
            start -= 1
        end
        return start
    end
end
