# frozen_string_literal: true
require_relative './chess_piece'

class Board
    attr_reader :board
    def initialize
        @board = create_board
        @w_king = [7, 4]
        @w_check = false
        @b_king = [0, 4]
        @b_check = false
        @turn = 1
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
        letters.map { |letter| print "       " + letter + " "}
        puts
        for row in 0..7
            print "#{8 - row} |"
            for column in 0..7
                if @board[row][column] != nil
                    print (row + column) % 2 == 0 ? Rainbow("#{@board[row][column]}").bg(:tan) : Rainbow("#{@board[row][column]}").bg(:olive)
                    print '|'
                else
                    print (row + column) % 2 == 0 ? Rainbow('        ').bg(:tan) : Rainbow('        ').bg(:olive)
                    print '|'
                end
            end
            puts " #{8 - row}"
        end
        letters.map { |letter| print "       " + letter + " "}
        puts
    end

    def validate_bounds(move1, move2)
        validate_bound(move1) && validate_bound(move2) ? true : false
    end

    def validate_bound(move)
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
        position1 = convert_move(move1)
        position2 = convert_move(move2)
        # Our move starts here
        @piece = @board[position1[0]][position1[1]]
        @finish = @board[position2[0]][position2[1]]

        # This goes to nil after our move is made.
        start_position = position1.dup

        # if check()
        #     puts 'You are in check, remember to move out of check.'
        # end
         
        if valid_move(position1, position2)
            # Update position in piece
            @piece.move(position2)
            if @piece.is_a?(Pawn) && (position2[0] == 0 || position2[0] == 7) # If pawn got to the end
                @board[position2[0]][position2[1]] = Queen.new(@piece.position, @piece.colour) # upgrade it to queen
            else
                # Move piece to new postion
                @board[position2[0]][position2[1]] = @piece
            end
            # Set original position to nil
            @board[start_position[0]][start_position[1]] = nil
            # check if a player has checked
            p @piece.position
            @check = false # set check flag back to false
            king_checks()
            is_check(@w_king)
            @turn += 1
            true
        else
            false
        end
    end

    def king_checks
        if is_check(@w_king)
            if @piece.colour == "white"
                puts "That move puts you in check. Try again."
                false
            else
                @check = true
                true
            end
        elsif is_check(@b_king) 
            if @piece.colour == "black"
                puts "That move puts you in check. Try again."
                false
            else
                @check = true
                true
            end
        end
    end

    # looks for check
    def is_check(king)
        valid_move(@piece.position, king) ? true : false
    end


    # Checks if a move is valid
    def valid_move(start, finish)
        if @piece == nil
            puts "You selected an empty square."
        elsif @piece.colour == 'white' && @turn % 2 != 1 || @piece.colour == 'black' && @turn % 2 != 0
            puts "That isn't your piece to move."
        elsif attacking_self(@piece.colour) 
            puts "You cannot take your own pieces."
        elsif @piece.is_a?(Pawn) && start[1] != finish[1] && @finish == nil
            "Your pawns can only move diagnoally when taking pieces."
        else
            return @piece.can_move(start, finish) && (@piece.can_jump || clear_steps(start, finish)) ? true : false
        end
        false
    end

    def attacking_self(colour)
        @finish == nil || @finish.colour != colour ? false : true
    end

    def clear_steps(start, finish)
        until step_to(finish[0], start[0]) == start[0] && step_to(finish[1], start[1]) == start[1]

            start[0] = step_to(start[0], finish[0])
            start[1] = step_to(start[1], finish[1])

            if @board[start[0]][start[1]] != nil
                puts "This piece cannot jump."
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
