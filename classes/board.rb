# frozen_string_literal: true
require_relative './chess_piece'

class Board
    def initialize
        @board = create_board
    end

    def print_board

        letters = *('A'..'H')
        letters.map { |letter| print "      " + letter + "   "}
        puts
        for row in 0..7
            print "#{8-row} "
            p @board[row]
            puts
        end
    end

    def convert_move(move)
        # takes a position eg a2 and converts it to array position
        return [8-move[1].to_i, move[0].downcase.ord-97]
    end

    def move_piece(move1, move2)
        postion1=convert_move(move1)
        position2=convert_move(move2)
        @board[position2[0]][position2[1]] = @board[postion1[0]][postion1[1]]
        @board[postion1[0]][postion1[1]] = '      '
        return(@board)
    end

    def create_board
        parts = [Castle, Knight, Bishop, Queen, King, Bishop, Knight, Castle]
        
        @board = []
        # setup black side of the board
        @board << (0..7).map { |item| parts[item].new([@board.length, item], "black")}
        @board << (0..7).map { |row| Pawn.new([@board.length, row], "black")}
        
        # adds empty spaces
        while @board.length < 6
            @board << ['      '] * 8
        end
        
        #setup white side of the board
        @board << (0..7).map { |row| Pawn.new([@board.length, row], "white")}
        @board << (0..7).map { |item| parts[item].new([@board.length, item], "white")}

        return @board
    end
end
