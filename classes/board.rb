# frozen_string_literal: true
require_relative './chess_piece'

class Board
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
        # Our move ends here
        @finish = @board[position2[0]][position2[1]]

        # Update position in piece
        if valid_move(position1, position2)
            viable_move = @piece.move(position2[0], position2[1])
            # Move piece to new postion, leave old position empty
            @board[position2[0]][position2[1]] = @piece
            @board[position1[0]][position1[1]] = nil
            return true
        else
            return false
        end
    end

    # Checks if a move is valid
    def valid_move(start, finish)
        if out_of_bounds(start[0], start[1]) || out_of_bounds(finish[0], finish[1]) || attacking_self(@piece.colour)
            puts "Out of bounds or self"
            return false
        end
        if @piece.can_move(start, finish)
            
            if @piece.can_jump
                puts "jumping"
                return true
            elsif clear_steps(start, finish)
                puts "clear steps"
                return true
            end
        end
        return false
    end
    
    def out_of_bounds(row, column)
        row >= 0 && row <= 7 && column >= 0 && column <= 7 ? false : true
    end

    def attacking_self(colour)
        if @finish == nil
            return false
        elsif @finish.colour != colour
            return false
        end
        puts "attacking self"
        return true
    end

    def clear_steps(start, finish)
        puts "trying steps"
        while (start[0] - finish[0]).abs >= 1 && (start[1] - finish[1]).abs >= 1
            p start
            p finish
            start[0] = step_to(start[0], finish[0])
            start[1] = step_to(start[1], finish[1])
            if @board[start[0]][start[1]] != nil
                return false
            end
        end
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
