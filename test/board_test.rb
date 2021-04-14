# frozen_string_literal: true
require 'test/unit'
require_relative '../classes/board'

class BoardTest < Test::Unit::TestCase
    def setup
        game1 = Board.new 
        # @customer = Customer.new("John", "Smith")
        # @customer2 = Customer.new("Jane", "Doe")
    end

    def test_positions
        begin 
        game1.board[0][0].is_a(Castle)
        game1.board[0][0].is_a(Knight)
        game1.board[0][0].is_a(Bishop)
        game1.board[0][0].is_a(Queen)
        game1.board[0][0].is_a(King)
        game1.board[1][0].is_a(Pawn)
        game.print_board
        rescue
            puts "no luck"
        end
    end

    # def test_new_instance
    #     assert_not_nil(@customer)
    # end
    # def test_new_no_params
    #     assert_raise(ArgumentError) {
    #         customer = Customer.new
end
